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

    private lazy var searchedMoviesGraph = SearchedMoviesGraph(cacheService: self.cacheService,
                                                               networkService: self.networkService,
                                                               coordinator: self.coordinator)

    // MARK: Settings

    func start(with tabBarController: UITabBarController) {
        configureTabBarAppearence()
        coordinator = CoordinatorImpl(
            tabBarController: tabBarController,
            cacheService: cacheService,
            networkService: networkService,
            searchedMoviesPresenter: self.searchedMoviesGraph.presenter
        )

        tabBarController.viewControllers = [
            moviesSamplingViewController,
            searchedMoviesGraph.viewController,
            movieListViewController
        ]
    }

    private func configureTabBarAppearence() {
        if #available(iOS 13.0, *) {
            let tabBarAppearance = UITabBarAppearance()
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
    func openFilterWindow()
    func openSearchWindow()
    func openSearchWindow(context: UIViewController, movies: [QueryMovieModel]?)

    func didSelectMovie(model: MovieDomainModel)
    func didSelectMovie(model: QueryMovieModel)
    func didSelectMovie(model: SearchedMovieViewItem)
}

// TODO: Will be moved
final class CoordinatorImpl: NSObject, Coordinator {
    private let tabBarController: UITabBarController
    private let cacheService: CacheService
    private let networkService: NetworkingService
    private var cancellation: CancellationHandle?
    private let searchedMoviesPresenter: () -> SearchedMoviePresenter

    init(
        tabBarController: UITabBarController,
        cacheService: CacheService,
        networkService: NetworkingService,
        searchedMoviesPresenter: @autoclosure @escaping (() -> SearchedMoviePresenter)
    ) {
        self.tabBarController = tabBarController
        self.cacheService = cacheService
        self.networkService = networkService
        self.searchedMoviesPresenter = searchedMoviesPresenter
    }

    func openSearchWindow() {
        tabBarController.selectedIndex = 1
    }

    func openFilterWindow() {
        let filterVC = FilterScreenViewController()
        tabBarController.present(filterVC, animated: true)
    }

    func openSearchWindow(context: UIViewController, movies: [QueryMovieModel]? = nil) {
        cancellation?.cancel()
        if let movies = movies {
            searchedMoviesPresenter().showMovies(movies)
        } else {
            searchedMoviesPresenter().showMovies([])
            cancellation = networkService.search(query: "") { [weak self] result in
                guard let movies = result else { return }
                self?.searchedMoviesPresenter().showMovies(movies)
            }
        }

        tabBarController.selectedIndex = 1
    }

    func didSelectMovie(model: MovieDomainModel) {
        let viewController = MovieDetailViewController(
            viewModel: MovieDetailViewModel(model: model),
            cache: cacheService,
            networkService: networkService
        )
        tabBarController.present(viewController, animated: true)
    }

    func didSelectMovie(model: QueryMovieModel) {
        let viewController = MovieDetailViewController(
            viewModel: MovieDetailViewModel(model: model),
            cache: cacheService,
            networkService: networkService
        )
        tabBarController.present(viewController, animated: true)
    }

    func didSelectMovie(model: SearchedMovieViewItem) {
        let viewController = MovieDetailViewController(
            viewModel: MovieDetailViewModel(model: model),
            cache: cacheService,
            networkService: networkService
        )
        tabBarController.present(viewController, animated: true)
    }
}
