//
//  NetworkingService.swift
//  KinoLenta
//
//  Created by Mikhail Kuimov on 14.12.2021.
//

import UIKit

class NetworkingService {
    let queue = DispatchQueue(label: "UrlQueue", attributes: .concurrent)

    func search(
        query: String,
        callback: @escaping ([QueryMovieModel]?) -> Void
    ) -> CancellationHandle {
        let cancellation = CancellationHandle()
        var queryInfo = getUrlItems(for: .search)
        queryInfo.queryItems.append(
            URLQueryItem(name: "query", value: query)
        )

        queue.async {
            assert(!Thread.isMainThread)
            makeRequest(with: queryInfo, cancellation: cancellation, callback: callback)
        }
        return cancellation
    }

    func discover(
        genre: [Int]?,
        yearRange: ClosedRange<Int>?,
        ratingGTE: Int?, country: String?,
        callback: @escaping ([QueryMovieModel]?) -> Void
    ) -> CancellationHandle {
        let cancellation = CancellationHandle()
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
            makeRequest(with: queryInfo, cancellation: cancellation) { result in
                assert(Thread.isMainThread)
                callback(result)
            }
        }
        return cancellation
    }

    func getById(_ id: Int, callback: @escaping (MovieDomainModel?) -> Void) -> CancellationHandle {
        let cancellation = CancellationHandle()
        let queryInfo = getUrlItems(for: .getById, id: id)
        queue.async {
            makeRequestSingleFilm(with: queryInfo, cancellation: cancellation, callback: callback)
        }
        return cancellation
    }

    func getSimilar(_ id: Int, callback: @escaping ([QueryMovieModel]?) -> Void) -> CancellationHandle {
        let cancellation = CancellationHandle()
        let queryInfo = getUrlItems(for: .getSimilar, id: id)
        queue.async {
            makeRequest(with: queryInfo, cancellation: cancellation, callback: callback)
        }
        return cancellation
    }

    func getPopular(callback: @escaping ([QueryMovieModel]?) -> Void) -> CancellationHandle {
        let cancellation = CancellationHandle()
        getCompilation(for: .getPopular, cancellation: cancellation, callback: callback)
        return cancellation
    }

    func getTopRated(callback: @escaping ([QueryMovieModel]?) -> Void) -> CancellationHandle {
        let cancellation = CancellationHandle()
        getCompilation(for: .getTopRated, cancellation: cancellation, callback: callback)
        return cancellation
    }

    func getTrending(callback: @escaping ([QueryMovieModel]?) -> Void) -> CancellationHandle {
        let cancellation = CancellationHandle()
        getCompilation(for: .getTrending, cancellation: cancellation, callback: callback)
        return cancellation
    }
}

enum RequestTypes {
    case search
    case discover
    case getPopular
    case getTopRated
    case getTrending
    case getById
    case getSimilar
}

struct QueryInfo {
    let pathItem : String
    var queryItems: [URLQueryItem]
}

extension NetworkingService {
    func getCompilation(
        for requestType: RequestTypes,
        cancellation: CancellationHandle,
        callback: @escaping ([QueryMovieModel]?) -> Void
    ) {
        let queryInfo = getUrlItems(for: requestType)
        queue.async {
            makeRequest(with: queryInfo, cancellation: cancellation) { result in
                assert(Thread.isMainThread)
                if !cancellation.isCancelled {
                    callback(result)
                }
            }
        }
    }
}

private func getUrlItems(for requestType: RequestTypes, id: Int? = nil) -> QueryInfo {
    lazy var token: String = APIKey.value
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
    case .getById:
        assert(id != nil)
        pathItem = "movie/\(id ?? 33)"
    case .getSimilar:
        assert(id != nil)
        pathItem = "movie/\(id ?? 33)/similar"
    }
    return QueryInfo(pathItem: pathItem, queryItems: queryItems)
}

private func makeRequest(
    with queryInfo: QueryInfo,
    cancellation: CancellationHandle,
    callback: @escaping ([QueryMovieModel]?) -> Void
) -> Void {
    func runCallback(_ result: [QueryMovieModel]?) {
        DispatchQueue.main.async {
            if !cancellation.isCancelled {
                callback(result)
            }
        }
    }

    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    guard let url = getUrl(with: queryInfo) else {
        assertionFailure()
        runCallback(nil)
        return
    }
    let task = session.dataTask(with: url) { data, response, error in
        assert(!Thread.isMainThread)
        if let error = error {
            print("Network request error: \(error)")
        }

        guard let content = data else {
            print("Network request returned no data")
            runCallback(nil)
            return
        }

        runCallback(parseModelFromResponse(data: content) as [QueryMovieModel])
    }
    cancellation.onCancelled {
        task.cancel()
    }
    task.resume()
}


private func makeRequestSingleFilm(
    with queryInfo: QueryInfo,
    cancellation: CancellationHandle,
    callback: @escaping (MovieDomainModel?) -> Void
) {
    func runCallback(_ result: MovieDomainModel?) {
        DispatchQueue.main.async {
            if !cancellation.isCancelled {
                callback(result)
            }
        }
    }

    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    guard let url = getUrl(with: queryInfo) else {
        assertionFailure()
        runCallback(nil)
        return
    }
    let task = session.dataTask(with: url) { data, response, error in
        assert(!Thread.isMainThread)
        if let error = error {
            print("Network request error: \(error)")
        }

        guard let content = data else {
            print("Network request returned no data")
            runCallback(nil)
            return
        }

        do {
            runCallback(try parseObj(data: content) as MovieDomainModel)
        } catch {
            print("Network request parsing error: \(error)")
            runCallback(nil)
        }
    }
    cancellation.onCancelled {
        task.cancel()
    }
    task.resume()
}

private func getUrl(with queryInfo: QueryInfo) -> URL? {
    var components = URLComponents()
    components.scheme = Endpoint.apiBaseURL.scheme
    components.host = Endpoint.apiBaseURL.host
    components.path = "/3/\(queryInfo.pathItem)"
    components.queryItems = queryInfo.queryItems
    return components.url
}

