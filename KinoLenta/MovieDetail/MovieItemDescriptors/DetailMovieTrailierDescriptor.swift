//
//  DetailMovieTrailierDescriptor.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 13.12.2021.
//

import Foundation
import UIKit
import AVFoundation

struct DetailMovieTrailerLayoutManager: LayoutManager {
    typealias CellType = DetailMovieTrailerCollectionViewCell

    func applyLayout(for cell: DetailMovieTrailerCollectionViewCell, bounds: CGRect) {
        cell.player.view.frame = bounds
    }

    func calculateHeight(width: CGFloat, font: UIFont, text: String) -> CGFloat {
        return text.height(withWidth: width, font: font)
    }
}

struct DetailMovieTrailerDescriptor: CollectionViewCellDescriptor {
    var cellClass: UICollectionReusableView.Type = DetailMovieTrailerCollectionViewCell.self
    let urlAsString: String
    private let layoutManager = DetailMovieTrailerLayoutManager()

    func sizeForItem(in collectionView: UICollectionView) -> CGSize {
        let width = collectionView.widthWithInsets
        let height: CGFloat = 250
        return CGSize(width: width, height: height)
    }

    func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        guard let cell = cell as? DetailMovieTrailerCollectionViewCell else {
            fatalError("Invalid cell type")
        }
        let path = Bundle.main.bundleURL.appendingPathComponent("film").appendingPathExtension(for: .mpeg4Movie)

        // will be removed
        let avPlayer = AVPlayer(url: path)
        cell.player.player = avPlayer
        cell.player.player?.play()
        return cell
    }
}
