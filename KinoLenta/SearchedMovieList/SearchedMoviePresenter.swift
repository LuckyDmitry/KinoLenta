//
//  SearchedMoviePresenter.swift
//  KinoLenta
//
//  Created by Trifonov Dmitry on 12/26/21.
//

import Foundation

protocol SearchedMoviePresenter: AnyObject {
    func moviePressed(movie: SearchedMovieViewItem)
    func addToWatchMoviePressed(movieItem: SearchedMovieViewItem, action: ((Result<String, Error>) -> ())?)
    func searchTextEditing(_ text: String)
    func filterButtonPressed()
    func viewLoaded()
    func showMovies(_ movies: [QueryMovieModel])
    func updateMovies()
}

final class SearchedMoviePresenterImpl: SearchedMoviePresenter {
    private weak var view: SearchedMoviesView?
    private let coordinator: Coordinator
    private let cacheService: CacheService
    private let networkService: NetworkingService
    
    private var moviesList: [QueryMovieModel] = []
    private var genreItems: [QuickItem] = []
    
    init(view: SearchedMoviesView,
         coordinator: Coordinator,
         cacheService: CacheService,
         networkService: NetworkingService) {
        self.view = view
        self.coordinator = coordinator
        self.cacheService = cacheService
        self.networkService = networkService
    }
    
    func showMovies(_ movies: [QueryMovieModel]) {
        cacheService.getSavedMovies(option: .wishToWatch, completion: { result in
            assert(Thread.isMainThread)
            switch result {
            case .success(let cacheMovies):
                let moviesSet = Set(cacheMovies.map { $0.id })
                self.view?.showMovies(movies.toSearchedMovieViewItems().map { SearchedMovieViewItem(id: $0.id, imageURL: $0.imageURL, title: $0.title, genre: $0.genre, overview: $0.overview, rating: $0.rating, buttonTitle: moviesSet.contains($0.id) ? "Remove from the list" : "Watch later")})
            case .failure(_):
                self.view?.showMovies([])
            }
        })
    }
    
    func updateMovies() {
        cacheService.getSavedMovies(option: .wishToWatch, completion: { result in
            assert(Thread.isMainThread)
            switch result {
            case .success(let cacheMovies):
                let moviesSet = Set(cacheMovies.map { $0.id })
                self.view?.showMovies(self.moviesList.toSearchedMovieViewItems().map { SearchedMovieViewItem(id: $0.id, imageURL: $0.imageURL, title: $0.title, genre: $0.genre, overview: $0.overview, rating: $0.rating, buttonTitle: moviesSet.contains($0.id) ? "Remove from the list" : "Watch later")})
            case .failure(_):
                self.view?.showMovies([])
            }
        })
    }
    
    func searchTextEditing(_ text: String) {
        networkService.search(query: text, callback: { model in
            guard let movies = model else { return }
            DispatchQueue.main.async { [weak self] in
                assert(Thread.isMainThread)
                self?.moviesList = movies
                self?.view?.showMovies(movies.toSearchedMovieViewItems())
            }
        })
    }
    
    func viewLoaded() {
        self.genreItems =  GenreDecoderContainer.sharedMovieManager.getGenreNames().map {
            QuickItem(title: $0)
        }
        view?.showGenres(genreItems)
    }
    
    func moviePressed(movie: SearchedMovieViewItem) {
        coordinator.didSelectMovie(model: movie)
    }
    
    func addToWatchMoviePressed(movieItem: SearchedMovieViewItem, action: ((Result<String, Error>) -> ())?) {
        cacheService.getSavedMovies(option: .wishToWatch, completion: { result in
            switch result {
            case .success(let cacheMovies):
                if cacheMovies.contains(where: { $0.id == movieItem.id }) {
                    action?(.success("Watch later"))
                    self.cacheService.removeMovies([movieItem.domainModel], directoryType: .wishToWatch, completion: nil)
                } else {
                    action?(.success("Remove from the list"))
                    self.cacheService.saveMovies([movieItem.domainModel], folderType: .wishToWatch, completion: nil)
                }
            case .failure(let error):
                action?(.failure(error))
            }
        })
    }
    
    func filterButtonPressed() {
        coordinator.openFilterWindow()
    }
}

extension SearchedMoviePresenterImpl: QuickItemFilterDelegate {
    func itemPressed(transition: Transition, isSelected: Bool) {
        let genreName: String?
        switch transition {
        case .singlePress(let index):
            genreName = isSelected ? genreItems[index].title.lowercased() : nil
            genreItems[index].isSelected = !genreItems[index].isSelected
        case .transitionPress(let indexBefore, let currentIndex):
            genreItems[indexBefore].isSelected = false
            genreItems[currentIndex].isSelected = true
            genreName = genreItems[currentIndex].title.lowercased()
        }
        if let genreName = genreName {
            retreiveMoviesFor(genreName: genreName)
        }
        moviesList.removeAll()
        view?.showMovies(moviesList.toSearchedMovieViewItems())
        view?.showGenres(genreItems)
    }
}

extension SearchedMoviePresenterImpl {
    private func retreiveMoviesFor(genreName: String) {
        let genreId = GenreDecoderContainer.sharedMovieManager.getByName(genreName).map { [$0] }
        
        networkService.discover(genre: genreId,
                                yearRange: nil,
                                ratingGTE: nil,
                                country: nil,
                                callback: { model in
            DispatchQueue.main.async { [weak self] in
                assert(Thread.isMainThread)
                self?.moviesList = model ?? []
                self?.view?.showMovies(self?.moviesList.toSearchedMovieViewItems() ?? [])
            }
        })
    }
}
