//
//  DetailMovieActorsDescriptor.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 11.12.2021.
//

import Foundation
import UIKit

struct DetailMovieActorsLayoutManager: LayoutManager {
    typealias CellType = DetailMovieActorsCollectionViewCell
    
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
                                                            .leadingMarhin),
            cell.secondaryLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            cell.secondaryLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
    }
    
    func calculateHeight(width: CGFloat, font: UIFont, text: String) -> CGFloat {
        return text.height(withWidth: width, font: font)
    }
    
    private enum Consts {
        static let leadingMarhin: CGFloat = 20
    }
}

struct DetailMovieActorsDescriptor: CollectionViewCellDescriptor {
    var cellClass: UICollectionReusableView.Type = DetailMovieActorsCollectionViewCell.self
    let primaryFont: UIFont
    let primaryTitle: String
    let secondaryFont: UIFont
    let secondaryTitle: String
    private let layoutManager = DetailMovieActorsLayoutManager()
    
    func sizeForItem(in collectionView: UICollectionView) -> CGSize {
        let width = collectionView.widthWithInsets
        
        let primaryWidth = primaryTitle.width(withHeight: .greatestFiniteMagnitude, font: primaryFont)

        let secondaryHeight = layoutManager.calculateHeight(width: width - primaryWidth,
                                                            font: secondaryFont,
                                                            text: secondaryTitle)
        return CGSize(width: width, height: secondaryHeight)
    }
    
    func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: cellClass)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        guard let cell = cell as? DetailMovieActorsCollectionViewCell else {
            fatalError("Invalid cell type")
        }
        
        cell.primaryLabel.text = primaryTitle
        cell.primaryLabel.font = primaryFont
        
        cell.secondaryLabel.text = secondaryTitle
        cell.secondaryLabel.font = secondaryFont
        return cell
        
    }
}
