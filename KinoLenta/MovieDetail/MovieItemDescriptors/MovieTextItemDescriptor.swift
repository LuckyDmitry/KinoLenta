//
//  MovieTextItemDescriptor.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 11.12.2021.
//

import Foundation
import UIKit

struct DetailMovieTextLayoutManager: LayoutManager {
    typealias CellType = DetailMovieTextCollectionViewCell
    
    func applyLayout(for cell: DetailMovieTextCollectionViewCell, bounds: CGRect) {
        cell.title.frame = bounds
    }
    
    func calculateHeight(width: CGFloat, font: UIFont, text: String) -> CGFloat {
        return text.height(withWidth: width, font: font)
    }
}

struct MovieTextItemDescriptor: CollectionViewCellDescriptor {
    var cellClass: UICollectionReusableView.Type = DetailMovieTextCollectionViewCell.self
    let title: String
    let font: UIFont
    var textColor: UIColor = .black
    var alignment: NSTextAlignment = .center
    var isMultiline: Bool = true
    private let layoutManager = DetailMovieTextLayoutManager()

    func sizeForItem(in collectionView: UICollectionView) -> CGSize {
        let width = collectionView.widthWithInsets
        let height = layoutManager.calculateHeight(width: width, font: font, text: title)
        return CGSize(width: width, height: height)
    }
    
    func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: cellClass)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        guard let cell = cell as? DetailMovieTextCollectionViewCell else {
            fatalError("Invalid cell type")
        }
        cell.title.numberOfLines = isMultiline ? 0 : 1
        cell.title.text = title
        cell.title.textAlignment = alignment
        cell.title.font = font
        cell.title.textColor = textColor
        return cell
    }
}
