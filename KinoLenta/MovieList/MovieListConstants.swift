//
//  MovieListConstants.swift
//  KinoLenta
//
//  Created by Mikhail Kuimov on 13.12.2021.
//

import UIKit


enum Constants {
    static let reuseId: String = String(describing: PosterCell.self)
    static var isLandscape: Bool { UIDevice.current.orientation.isLandscape }
    static let backGroundColor: UIColor = UIColor(named: "mainBackground") ?? .white
    static let selectedItemColor: UIColor = UIColor(named: "selectedItemBackground") ?? .black
    static let defaultCellWidth: CGFloat = 180
    static let cellHeight: CGFloat = 270
    static let buttonCornerRadius: CGFloat = 10
    static let cellCornerRadius: CGFloat = 5
}
