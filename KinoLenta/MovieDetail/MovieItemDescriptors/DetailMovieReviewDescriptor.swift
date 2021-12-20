//
//  DetailMovieReview.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 12.12.2021.
//

import Foundation
import UIKit

struct DetailMovieReviewLayoutManager: LayoutManager {
    typealias CellType = DetailMovieReviewCollectionViewCell
    
    func applyLayout(for cell: DetailMovieReviewCollectionViewCell, bounds: CGRect) {
        cell.userImage.translatesAutoresizingMaskIntoConstraints = false
        cell.nickname.translatesAutoresizingMaskIntoConstraints = false
        cell.reviewText.translatesAutoresizingMaskIntoConstraints = false
        cell.openFullReviewButton.translatesAutoresizingMaskIntoConstraints = false
        
        cell.userImage.layer.cornerRadius = floor(bounds.width * Consts.imageSizeMultiplier)
        
        NSLayoutConstraint.activate([
            cell.userImage.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: Consts.horizontalMargin),
            cell.userImage.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            cell.userImage.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: Consts.imageSizeMultiplier),
            cell.userImage.heightAnchor.constraint(equalTo: cell.userImage.widthAnchor),
            
            cell.nickname.leadingAnchor.constraint(equalTo: cell.userImage.trailingAnchor, constant: Consts
                                                    .horizontalMargin),
            cell.nickname.centerYAnchor.constraint(equalTo: cell.userImage.centerYAnchor),
            cell.nickname.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -Consts.horizontalMargin),
            
            cell.reviewText.topAnchor.constraint(equalTo: cell.userImage.bottomAnchor, constant: Consts.verticalMargin),
            cell.reviewText.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: Consts.horizontalMargin),
            cell.reviewText.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -Consts.horizontalMargin),
            cell.reviewText.bottomAnchor.constraint(equalTo: cell.openFullReviewButton.topAnchor),
            
            cell.openFullReviewButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            cell.openFullReviewButton.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            cell.openFullReviewButton.heightAnchor.constraint(equalToConstant: Consts.openButtonHeight)
        ])
    }
    
    func calculateHeight(width: CGFloat, text: String, font: UIFont) -> CGFloat {
        let reviewTextHeight = text.height(withWidth: width, font: font)
        let height = reviewTextHeight + floor(width * Consts.imageSizeMultiplier) + Consts.openButtonHeight
        return height
    }
    
    private enum Consts {
        static let horizontalMargin: CGFloat = 10
        static let openButtonHeight: CGFloat = 30
        static let verticalMargin: CGFloat = 5
        static let imageSizeMultiplier: CGFloat = 0.1
    }
}

struct DetailMovieReviewDescriptor: CollectionViewCellDescriptor {
    let cellClass: UICollectionReusableView.Type = DetailMovieReviewCollectionViewCell.self
    var image: UIImage? = nil
    let nickname: String
    let nicknameFont: UIFont
    let reviewText: String
    let reviewFont: UIFont
    // If review is too long, we can hide it.
    var heightThreshold: CGFloat
    let openFullReviewButtonTitle: String =
        NSLocalizedString("movie_details_screen_show_full_review_action",
                          comment: "Show full review action title on movie details screen")
    var openMoreHandler: (() -> ())? = nil
    
    private let layoutManager = DetailMovieReviewLayoutManager()
    
    func sizeForItem(in collectionView: UICollectionView) -> CGSize {
        let width = collectionView.widthWithInsets
        let height = layoutManager.calculateHeight(width: width, text: reviewText, font: reviewFont)
        return CGSize(width: width, height: min(heightThreshold, height))
    }
    
    func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        guard let cell = cell as? DetailMovieReviewCollectionViewCell else { fatalError("Incorrect cell type") }
        cell.nickname.text = nickname
        cell.nickname.font = nicknameFont
        cell.reviewText.text = reviewText
        cell.reviewText.font = reviewFont
        cell.userImage.image = image
        let height = layoutManager.calculateHeight(width: collectionView.widthWithInsets,
                                                   text: reviewText,
                                                   font: reviewFont)
        let isHidden = height < heightThreshold
        cell.openFullReviewButton.isHidden = isHidden
        cell.openFullReviewButton.setTitle(openFullReviewButtonTitle, for: .normal)
        cell.openFullReviewButton.addAction(UIAction(handler: { action in
            openMoreHandler?()
        }), for: .touchUpInside)
        return cell
    }
}
