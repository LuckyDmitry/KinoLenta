//
//  MainGraph.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 09.12.2021.
//

import Foundation
import UIKit

final class MainGraph {
    
    func start(with controller: UINavigationController) {
        let rating = UIStoryboard(name: "Films", bundle: nil).instantiateViewController(withIdentifier: "FilmId")
        controller.pushViewController(rating, animated: true)
    }
}

