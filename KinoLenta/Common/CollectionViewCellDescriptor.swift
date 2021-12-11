//
//  MovieCellItem.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 11.12.2021.
//

import Foundation
import UIKit

protocol CollectionViewCellDescriptor {
    var cellClass: UICollectionReusableView.Type { get }
    func sizeForItem(in collectionView: UICollectionView) -> CGSize
    func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
}
