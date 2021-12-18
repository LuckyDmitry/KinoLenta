//
//  DetailMovieItemDescriptor.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 11.12.2021.
//

import Foundation
import UIKit

struct DetailMovieImageLayoutManager: LayoutManager {
    typealias CellType = DetailMovieImageCollectionViewCell
    
    func applyLayout(for cell: CellType, bounds: CGRect) {
        cell.imageView.frame = bounds
    }
    
    func calculateHeight(width: CGFloat) -> CGSize {
        let height = floor(width * Consts.ratio)
        return CGSize(width: width, height: height)
    }
    
    private enum Consts {
        static let ratio = 0.7
    }
}

struct DetailMovieImageDescriptor: CollectionViewCellDescriptor {
    let cellClass: UICollectionReusableView.Type = DetailMovieImageCollectionViewCell.self
    let imageUrl: URL?
    var inset: UIEdgeInsets = .zero
    private let placeholderImage = UIImage.moviePlaceholder
    private let layoutManager = DetailMovieImageLayoutManager()
    
    func sizeForItem(in collectionView: UICollectionView) -> CGSize {
        layoutManager.calculateHeight(width: collectionView.widthWithInsets )
    }
    
    func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        guard let cell = cell as? DetailMovieImageCollectionViewCell else {
            fatalError("Invalid cell type")
        }
        cell.cancellationHandle?.isCancelled = true
        if let imageUrl = imageUrl {
            cell.cancellationHandle = cell.imageView.setImage(url: imageUrl)
        }
        cell.insets = inset
        return cell
        
    }
}
