//
//  SearchedMoviesGraph.swift
//  KinoLenta
//
//  Created by Trifonov Dmitry on 12/26/21.
//

import UIKit

final class SearchedMoviesGraph {
    let viewController: UIViewController
    let presenter: SearchedMoviePresenter
    let networkService: NetworkingService
    let cacheService: CacheService
    let coordinator: Coordinator
    
    init(cacheService: CacheService,
         networkService: NetworkingService,
         coordinator: Coordinator) {
        self.cacheService = cacheService
        self.networkService = networkService
        self.coordinator = coordinator
 
        let searchedViewController = SearchedMoviesViewController()
        let presenter = SearchedMoviePresenterImpl(view: searchedViewController,
                                                   coordinator: coordinator,
                                                   cacheService: cacheService,
                                                   networkService: networkService)
        searchedViewController.presenter = presenter
        self.presenter = presenter

        searchedViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("search_tab_title", comment: "Tab title for movie search"),
            image: .magnifyingGlass,
            selectedImage: .magnifyingGlass
        )
        
        self.viewController = UINavigationController(rootViewController: searchedViewController)
    }
    
}
