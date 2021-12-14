//
//  DetailMovieButtonActions.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 13.12.2021.
//

import Foundation
import UIKit

struct DetailMovieButtonActionsLayoutManager: LayoutManager {
    typealias CellType = DetailMovieButtonActionsCollectionViewCell
    
    func applyLayout(for cell: DetailMovieButtonActionsCollectionViewCell, bounds: CGRect) {
        cell.filterComponent.frame = bounds
    }
    
    func calculateSize(width: CGFloat) -> CGSize {
        return .init(width: width, height: 40)
    }
}

struct DetailMovieButtonActionsDescriptor: CollectionViewCellDescriptor {
    var cellClass: UICollectionReusableView.Type = DetailMovieButtonActionsCollectionViewCell.self
    let items: [QuickItem]
    private let layoutManager = DetailMovieButtonActionsLayoutManager()
    
    func sizeForItem(in collectionView: UICollectionView) -> CGSize {
        layoutManager.calculateSize(width: collectionView.widthWithInsets)
    }
    
    func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: cellClass)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        guard let cell = cell as? DetailMovieButtonActionsCollectionViewCell else {
            fatalError("Invalid cell type")
        }
        cell.filterComponent.items = items
        return cell 
    }
}
