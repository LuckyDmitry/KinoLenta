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
        
        let movieSamplingVC = MoviesSamplingViewController()
        movieSamplingVC.coordinator = CoordinatorImpl()
        
        let movieListStoryboard = UIStoryboard(name: "MovieList", bundle: nil)
        configureTabBarAppearence()
        let movieListViewController = movieListStoryboard.instantiateViewController(withIdentifier: "MovieList") as! MovieListViewController

        movieListViewController.setCoordinator(CoordinatorImpl())
        
        movieListViewController.tabBarItem = UITabBarItem(title: "Movie List", image: nil, selectedImage: nil)
        movieSamplingVC.tabBarItem = UITabBarItem(title: "Movie Sampling", image: nil, selectedImage: nil)
        
        tabBarController.viewControllers = [movieSamplingVC, movieListViewController]
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
    func openFilterWindow(context: UIViewController)
    func openSearchWindow(context: UIViewController)
}


// TODO: Will be moved
final class CoordinatorImpl: Coordinator {
    
    let dataProvider = MockDataManager()
    
    func openDetailMovie(withMovieId id: Int, context: UIViewController) {
        let detailMovieViewController = MovieDetailViewController()
        detailMovieViewController.buttonActions = [(.viewed, QuickItem(title: "Просмотрено")),
                                                   (.wishToWatch, QuickItem(title: "Посмотреть"))]
        context.present(detailMovieViewController, animated: true)
    }
    
    func openFilterWindow(context: UIViewController) {
        let filterVC = FilterScreenViewController()
        
        context.present(filterVC, animated: true)
    }
    
    func openSearchWindow(context: UIViewController) {
        let searchedMoviesStoryboard = UIStoryboard(name: "SearchedMovies", bundle: nil)

        let searchedMovieViewController = searchedMoviesStoryboard.instantiateViewController(withIdentifier: "SearchedMovies") as! SearchedMoviesViewController
        
        searchedMovieViewController.setDisplayedItems(queryResults: dataProvider.search(query: "").toSearchedMovieViewItems())
        searchedMovieViewController.coordinator = self

        searchedMovieViewController.filterItems = GenreDecoderContainer.sharedMovieManager.getGenreNames().map {
            QuickItem(title: $0)
        }
        
        context.present(searchedMovieViewController, animated: true)
    }
}
