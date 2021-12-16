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
        let dataProvider = MockDataManager()
        
        let searchedMoviesStoryboard = UIStoryboard(name: "SearchedMovies", bundle: nil)
        let movieListStoryboard = UIStoryboard(name: "MovieList", bundle: nil)
        configureTabBarAppearence()
        
        let searchedMovieViewController = searchedMoviesStoryboard.instantiateViewController(withIdentifier: "SearchedMovies") as! SearchedMoviesViewController
        searchedMovieViewController.filterItems = GenreDecoderContainer.sharedMovieManager.getGenreNames().map {
            QuickItem(title: $0)
        }
        searchedMovieViewController.tabBarItem = UITabBarItem(title: "Searched", image: nil, selectedImage: nil)
        searchedMovieViewController.coordinator = CoordinatorImpl()
        searchedMovieViewController.setDisplayedItems(queryResults: dataProvider.search(query: "").toSearchedMovieViewItems())
        
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
