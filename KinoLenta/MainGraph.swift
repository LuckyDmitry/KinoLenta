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
        let rating = UIStoryboard(name: "SearchedMovies", bundle: nil).instantiateViewController(withIdentifier: "FilmId")
        rating.tabBarItem = UITabBarItem(title: "Searched", image: nil, selectedImage: nil)
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.viewControllers = [rating]
    }
}

