//
//  MainGraph.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 09.12.2021.
//

import Foundation
import UIKit

final class MainGraph {
    var coordinator: Coordinator!
    func start(with tabBarController: UITabBarController) {
<<<<<<< HEAD
        let searchedMoviesStoryboard = UIStoryboard(name: "SearchedMovies", bundle: nil)
        let movieListStoryboard = UIStoryboard(name: "MovieList", bundle: nil)
        configureTabBarAppearence()
        
        let searchedMovieViewController = searchedMoviesStoryboard.instantiateViewController(withIdentifier: "SearchedMovies") as! SearchedMoviesViewController
        searchedMovieViewController.filterItems = [QuickItem(title: "Ужасы"), QuickItem(title: "Боевик"), QuickItem(title: "Драма"), QuickItem(title: "Фантастика"), QuickItem(title: "Комедии")]
        searchedMovieViewController.tabBarItem = UITabBarItem(title: "Searched", image: nil, selectedImage: nil)
        searchedMovieViewController.coordinator = CoordinatorImpl()
        
        let movieListViewController = movieListStoryboard.instantiateViewController(withIdentifier: "MovieList")
        movieListViewController.tabBarItem = UITabBarItem(title: "Movie list", image: nil, selectedImage: nil)
        
        tabBarController.viewControllers = [searchedMovieViewController, movieListViewController]
    }
    
    private func configureTabBarAppearence() {
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = UIColor.white
            UITabBar.appearance().standardAppearance = tabBarAppearance

            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
=======
        let dataManager = MockDataManager()
        
        let navigationController = UINavigationController()
        let rating = UIStoryboard(name: "MovieList", bundle: nil).instantiateViewController(withIdentifier: "MovieList") as! MovieListViewController
        rating.tabBarItem = UITabBarItem(title: "Сохраненные", image: nil, selectedImage: nil)

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBarController.tabBar.standardAppearance = appearance
<<<<<<< HEAD
        tabBarController.viewControllers = [rating, search]
>>>>>>> 079e435 (Add datasource array to SearchedMoviesVC)
=======
        tabBarController.viewControllers = [rating]
>>>>>>> 2bcbc1e (Apply suggestions: convertion to higher order functions, create namespace)
    }
}

// TODO: Will be moved
protocol Coordinator {
    func openDetailMovie(withMovieId id: Int, context: UIViewController)
}

// TODO: Will be moved
final class CoordinatorImpl: Coordinator {
    func openDetailMovie(withMovieId id: Int, context: UIViewController) {
        let detailMovieViewController = MovieDetailViewController()
        detailMovieViewController.buttonActions = [(.viewed, QuickItem(title: "Посмотреть")),
                                                   (.all, QuickItem(title: "Посмотреть"))]
        context.present(detailMovieViewController, animated: true)
    }
}
