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
            searchedMoviesStoryboard
                .instantiateViewController(withIdentifier: "SearchedMovies") as! SearchedMoviesViewController

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
        coordinator = CoordinatorImpl(
            tabBarController: tabBarController,
            cacheService: cacheService,
            networkService: networkService
        )

        tabBarController.viewControllers = [
            moviesSamplingViewController,
            searchedMovieViewController,
            movieListViewController
        ]
    }

    private func configureTabBarAppearence() {
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = .init()
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
    func openFilterWindow(context: UIViewController)
    func openSearchWindow()
    func openSearchWindow(context: UIViewController, movies: [QueryMovieModel]?)

    func didSelectMovie(model: MovieDomainModel, in context: UIViewController)
    func didSelectMovie(model: QueryMovieModel, in context: UIViewController)
    func didSelectMovie(model: SearchedMovieViewItem, in context: UIViewController)
}

// TODO: Will be moved
final class CoordinatorImpl: Coordinator {
    private let tabBarController: UITabBarController
    private let cacheService: CacheService
    private let networkService: NetworkingService

    init(
        tabBarController: UITabBarController,
        cacheService: CacheService,
        networkService: NetworkingService
    ) {
        self.tabBarController = tabBarController
        self.cacheService = cacheService
        self.networkService = networkService
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
        } else {
            controller.setDisplayedItems(queryResults: [])
            _ = networkService.search(query: "") { result in
                guard let movies = result else { return }
                controller.setDisplayedItems(queryResults: movies.toSearchedMovieViewItems())
            }
        }

        tabBarController.selectedIndex = 1
    }

    func didSelectMovie(model: MovieDomainModel, in context: UIViewController) {
        let viewController = MovieDetailViewController(
            viewModel: MovieDetailViewModel(model: model),
            cache: cacheService,
            networkService: networkService
        )
        context.present(viewController, animated: true)
    }

    func didSelectMovie(model: QueryMovieModel, in context: UIViewController) {
        let viewController = MovieDetailViewController(
            viewModel: MovieDetailViewModel(model: model),
            cache: cacheService,
            networkService: networkService
        )
        context.present(viewController, animated: true)
    }

    func didSelectMovie(model: SearchedMovieViewItem, in context: UIViewController) {
        let viewController = MovieDetailViewController(
            viewModel: MovieDetailViewModel(model: model),
            cache: cacheService,
            networkService: networkService
        )
        context.present(viewController, animated: true)
    }
}
