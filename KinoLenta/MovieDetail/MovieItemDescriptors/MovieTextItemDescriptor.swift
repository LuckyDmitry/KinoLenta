//
//  MovieTextItemDescriptor.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 11.12.2021.
//

import Foundation
import UIKit

struct MovieTextItemDescriptor: CollectionViewCellDescriptor {
    var cellClass: UICollectionReusableView.Type = MovieTextItemCollectionViewCell.self
    let font: UIFont
    let title: String
    
    func sizeForItem(in collectionView: UICollectionView) -> CGSize {
        let width = collectionView.bounds.width
        let height = title.height(withWidth: width, font: font)
        return CGSize(width: width, height: height)
    }
    
    func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: cellClass)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        guard let cell = cell as? MovieTextItemCollectionViewCell else {
            fatalError("Invalid cell type")
        }
        
        cell.backgroundColor = .red
        cell.title.text = title
        cell.title.font = font
        return cell
        
    }
}
