//
//  MainGraph.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 09.12.2021.
//

import Foundation
import UIKit

final class MainGraph {
    
    func start(with tabBarController: UITabBarController) {
        let navigationController = UINavigationController()
        let searchedMovies = UIStoryboard(name: "SearchedMovies", bundle: nil)
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = UIColor.white
            UITabBar.appearance().standardAppearance = tabBarAppearance

            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
        
        // will be changed
        let searchedMovieViewController = searchedMovies.instantiateViewController(withIdentifier: "SearchedMovies") as! SearchedMoviesViewController
        searchedMovieViewController.filterItems = [QuickItem(title: "Ужасы"), QuickItem(title: "Боевик"), QuickItem(title: "Драма"), QuickItem(title: "Фантастика"), QuickItem(title: "Комедии")]
        searchedMovieViewController.tabBarItem = UITabBarItem(title: "Searched", image: nil, selectedImage: nil)
        let rating = UIStoryboard(name: "MovieList", bundle: nil).instantiateViewController(withIdentifier: "MovieList")
        rating.tabBarItem = UITabBarItem(title: "Movie list", image: nil, selectedImage: nil)
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.viewControllers = [rating, searchedMovieViewController]
    }
}

