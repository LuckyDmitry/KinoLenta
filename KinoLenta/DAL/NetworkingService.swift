//
//  NetworkingService.swift
//  KinoLenta
//
//  Created by Mikhail Kuimov on 14.12.2021.
//

import UIKit

class NetworkingService {
    let queue = DispatchQueue(label: "UrlQueue", attributes: .concurrent)
    
    func search(query: String, callback: @escaping ([QueryMovieModel]) -> Void) {
        var queryInfo = getUrlItems(for: .search)
        queryInfo.queryItems.append(
            URLQueryItem(name: "query", value: query)
        )

        queue.async {
            assert(!Thread.isMainThread)
            makeRequest(with: queryInfo, callback: callback)
        }
    }
    
    func discover(
        genre: [Int]?,
        yearRange: ClosedRange<Int>?,
        ratingGTE: Int?, country: String?,
        callback: @escaping ([QueryMovieModel]) -> Void
    ) {
        var queryInfo = getUrlItems(for: .discover)
        if let leftYearBound = yearRange?.lowerBound {
            queryInfo.queryItems.append(
                URLQueryItem(name: "primary_release_date.gte", value: "\(leftYearBound)-01-01")
            )
        }
        if let rightYearBound = yearRange?.upperBound {
            queryInfo.queryItems.append(
                URLQueryItem(name: "primary_release_date.lte", value: "\(rightYearBound)-12-31")
            )
        }
        if let ratingGTE = ratingGTE {
            queryInfo.queryItems.append(
                URLQueryItem(name: "vote_average.gte", value: "\(ratingGTE)")
            )
        }
        if let country = country {
            queryInfo.queryItems.append(
                URLQueryItem(name: "region", value: "\(country)")
            )
        }
        if let genres = genre {
            let genresStringArray = genres.map({"\($0)"})
            let genre_string = genresStringArray.joined(separator: ", ")
            queryInfo.queryItems.append(
                URLQueryItem(name: "with_genres", value: genre_string)
            )
        }
        queue.async {
            assert(!Thread.isMainThread)
            makeRequest(with: queryInfo, callback: callback)
        }
    }
    
    func getById(_ id: Int) -> [MovieDomainModel] {
        []
    }
    
    func getRecommendations(for movie: MovieDomainModel) -> [MovieDomainModel] {
        []
    }
    
    func getSimilar(to movie: MovieDomainModel) -> [MovieDomainModel] {
        []
    }
    
    func getPopular(callback: @escaping ([QueryMovieModel]) -> Void) {
        getCompilation(for: .getPopular, using: callback)
    }
    
    func getTopRated(callback: @escaping ([QueryMovieModel]) -> Void) {
        getCompilation(for: .getTopRated, using: callback)
    }
    
    func getTrending(callback: @escaping ([QueryMovieModel]) -> Void) {
        getCompilation(for: .getTrending, using: callback)
    }
    
    func getSavedMovies(option: SavedMovieOption) -> [MovieDomainModel] {
        []
    }
    
}

enum RequestTypes {
    case search
    case discover
    case getPopular
    case getTopRated
    case getTrending
}

struct QueryInfo {
    let pathItem : String
    var queryItems: [URLQueryItem]
}

extension NetworkingService {
    func getCompilation(for requestType: RequestTypes, using callback:  @escaping ([QueryMovieModel]) -> Void) {
        let queryInfo = getUrlItems(for: requestType)
        queue.async {
            assert(!Thread.isMainThread)
            makeRequest(with: queryInfo, callback: callback)
        }
    }
}

func getUrlItems(for requestType: RequestTypes) -> QueryInfo {
    lazy var token: String = ApiKey.value
    var queryItems: [URLQueryItem] = []
    let queryItemToken = URLQueryItem(name: "api_key", value: token)
    let queryItemLang = URLQueryItem(name: "language", value: "ru")
    let queryItemPage = URLQueryItem(name: "page", value: "1")
    queryItems.append(queryItemToken)
    queryItems.append(queryItemLang)
    queryItems.append(queryItemPage)
    var pathItem = ""
    switch requestType {
    case .getPopular:
        pathItem = "movie/popular"
    case .getTopRated:
        pathItem = "movie/top_rated"
    case .getTrending:
        pathItem = "trending/movie/day"
    case .search:
        pathItem = "search/multi"
        let queryItemAdult = URLQueryItem(name: "include_adult", value: "true")
        queryItems.append(queryItemAdult)
    case .discover:
        pathItem = "discover/movie"
        let queryItemSort = URLQueryItem(name: "sort_by", value: "popularity.desc")
        let queryItemAdult = URLQueryItem(name: "include_adult", value: "true")
        let queryItemWatchMonetization = URLQueryItem(name: "with_watch_monetization_types", value: "flatrate")
        queryItems.append(queryItemSort)
        queryItems.append(queryItemAdult)
        queryItems.append(queryItemWatchMonetization)
    }
    return QueryInfo(pathItem: pathItem, queryItems: queryItems)
}

func makeRequest(with queryInfo: QueryInfo, callback:  @escaping ([QueryMovieModel]) -> Void) {
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)

    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.themoviedb.org"
    components.path = "/3/\(queryInfo.pathItem)"
    components.queryItems = queryInfo.queryItems

    guard let url = components.url else {
        print("url can't be composed")
        return
    }

    let task = session.dataTask(with: url) { data, response, error in
        assert(!Thread.isMainThread)
        guard error == nil else {
            print ("error: \(error!)")
            return
        }
        
        guard let content = data else {
            print("No data")
            return
        }
        
        let response: [QueryMovieModel] = parseModelFromData(data: content)
        DispatchQueue.main.async {
            assert(Thread.isMainThread)
            callback(response)
        }
    }
    
    task.resume()
}
    
