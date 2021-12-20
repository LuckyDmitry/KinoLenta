//
//  MainGraph.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 09.12.2021.
//

import Foundation
import UIKit

final class MainGraph {
    private var coordinator: Coordinator!
    private lazy var dataProvider = MockDataManager()
    private lazy var cacheService = CacheService()
    private lazy var networkService = NetworkingService()
    
    // MARK: - Views
    private lazy var movieListViewController: MovieListViewController = {
        let movieListStoryboard = UIStoryboard(name: "MovieList", bundle: nil)
        let movieListViewController =
            movieListStoryboard.instantiateViewController(withIdentifier: "MovieList") as! MovieListViewController

        movieListViewController.coordinator = coordinator
        movieListViewController.cacheService = cacheService
        movieListViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("favorites_tab_title", comment: "Tab title for selected movies"),
            image: .listAndFilm,
            selectedImage: .listAndFilm
        )
        return movieListViewController
    }()
    
    private lazy var moviesSamplingViewController: MoviesSamplingViewController = {
        let moviesSamplingViewController = MoviesSamplingViewController()
        moviesSamplingViewController.coordinator = coordinator
        moviesSamplingViewController.dataProvider = networkService

        moviesSamplingViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("featured_tab_title", comment: "Tab title for featured collections"),
            image: .film,
            selectedImage: .film
        )
        return moviesSamplingViewController
    }()
    
    private lazy var searchedMovieViewController: SearchedMoviesViewController = {
        let searchedMoviesStoryboard = UIStoryboard(name: "SearchedMovies", bundle: nil)

        let searchedMovieViewController =
            searchedMoviesStoryboard.instantiateViewController(withIdentifier: "SearchedMovies") as! SearchedMoviesViewController
    
        searchedMovieViewController.coordinator = coordinator
        searchedMovieViewController.cacheService = cacheService
        searchedMovieViewController.networkService = networkService

        searchedMovieViewController.filterItems = GenreDecoderContainer.sharedMovieManager.getGenreNames().map {
            QuickItem(title: $0)
        }

        searchedMovieViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("search_tab_title", comment: "Tab title for movie search"),
            image: .magnifyingGlass,
            selectedImage: .magnifyingGlass
        )
        return searchedMovieViewController
    }()
        
    // MARK: Settings
    func start(with tabBarController: UITabBarController) {
        configureTabBarAppearence()
        coordinator = CoordinatorImpl(tabBarController: tabBarController)
    

        tabBarController.viewControllers = [moviesSamplingViewController, searchedMovieViewController, movieListViewController]
    }

    private func configureTabBarAppearence() {
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = .mainBackground
            UITabBar.appearance().tintColor = .buttonActiveBackground
            UITabBar.appearance().standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
}

// TODO: Will be moved
protocol Coordinator {
    func openDetailMovie(withMovieId id: Int, context: UIViewController, completion: (() -> ())?)
    func openFilterWindow(context: UIViewController)
    func openSearchWindow()
    func openSearchWindow(context: UIViewController, movies: [QueryMovieModel]?)
}

// TODO: Will be moved
final class CoordinatorImpl: Coordinator {

    let tabBarController: UITabBarController
    
    let dataProvider = MockDataManager()
    
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    func openDetailMovie(withMovieId id: Int, context: UIViewController, completion: (() -> ())? = nil) {
        let detailMovieViewController = MovieDetailViewController()
        detailMovieViewController.buttonActions = [
            (.wishToWatch, QuickItem(title: NSLocalizedString("add_to_wishlist_action",
                                                              comment: "Action title for adding to watchlist"))),
            (.viewed, QuickItem(title: NSLocalizedString("add_to_watched_list_action",
                                                         comment: "Action title adding to already watched list"))),
        ]
        detailMovieViewController.cache = CacheService()
        detailMovieViewController.idMovie = id
        detailMovieViewController.service = NetworkingService()
        context.present(detailMovieViewController, animated: true)
    }
    
    func openSearchWindow() {
        tabBarController.selectedIndex = 1
    }

    func openFilterWindow(context: UIViewController) {
        let filterVC = FilterScreenViewController()
        
        context.present(filterVC, animated: true)
    }
    
    func openSearchWindow(context: UIViewController, movies: [QueryMovieModel]? = nil) {
        let controller = tabBarController.viewControllers![1] as! SearchedMoviesViewController
        if let movies = movies {
            controller.setDisplayedItems(queryResults: movies.toSearchedMovieViewItems())
        }
        else {
            controller.setDisplayedItems(queryResults: dataProvider.search(query: "").toSearchedMovieViewItems())
        }
        
        tabBarController.selectedIndex = 1
    }
}
