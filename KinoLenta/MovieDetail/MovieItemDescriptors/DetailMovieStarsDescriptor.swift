//
//  DetailMovieStarsLayoutManager.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 11.12.2021.
//

import Foundation
import UIKit

struct DetailMovieStarsLayoutManager: LayoutManager {
    typealias CellType = DetailMovieStarsCollectionViewCell
    
    func applyLayout(for cell: CellType, bounds: CGRect) {
        
        cell.primaryLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cell.secondaryLabel.setContentCompressionResistancePriority(.defaultLow - 1, for: .horizontal)

        NSLayoutConstraint.activate([
            cell.primaryLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            cell.primaryLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            
            cell.secondaryLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            cell.secondaryLabel.leadingAnchor.constraint(equalTo: cell.primaryLabel.trailingAnchor,
                                                         constant: Consts
                                                            .leadingMargin),
            cell.secondaryLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            cell.secondaryLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
    }
    
    func calculateHeight(width: CGFloat, font: UIFont, text: String) -> CGFloat {
        return text.height(withWidth: width, font: font)
    }
    
    private enum Consts {
        static let leadingMargin = 20.0
    }
}

struct DetailMovieStarsDescriptor: CollectionViewCellDescriptor {
    var cellClass: UICollectionReusableView.Type = DetailMovieStarsCollectionViewCell.self
    let primaryFont: UIFont
    let primaryTitle: String
    let secondaryFont: UIFont
    let secondaryTitle: String
    private let layoutManager = DetailMovieStarsLayoutManager()
    
    func sizeForItem(in collectionView: UICollectionView) -> CGSize {
        let width = collectionView.widthWithInsets
        
        let primaryWidth = primaryTitle.width(withHeight: .greatestFiniteMagnitude, font: primaryFont)

        let secondaryHeight = layoutManager.calculateHeight(width: width - primaryWidth,
                                                            font: secondaryFont,
                                                            text: secondaryTitle)
        return CGSize(width: width, height: secondaryHeight)
    }
    
    func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        guard let cell = cell as? DetailMovieStarsCollectionViewCell else {
            fatalError("Invalid cell type")
        }
        
        cell.primaryLabel.text = primaryTitle
        cell.primaryLabel.font = primaryFont
        
        cell.secondaryLabel.text = secondaryTitle
        cell.secondaryLabel.font = secondaryFont
        return cell
        
    }
}
