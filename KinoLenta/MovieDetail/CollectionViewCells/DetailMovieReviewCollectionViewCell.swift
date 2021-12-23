//
//  DetailMovieReviewCollectionViewCell.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 12.12.2021.
//

import UIKit

final class DetailMovieReviewCollectionViewCell: UICollectionViewCell {
    let userImage: UIImageView = {
        let userImage = UIImageView()
        userImage.clipsToBounds = true
        return userImage
    }()

    let nickname = UILabel()

    let reviewText: UILabel = {
        let reviewText = UILabel()
        reviewText.numberOfLines = 0
        return reviewText
    }()

    let openFullReviewButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.darkTextForeground, for: .normal)
        return button
    }()

    private let layoutManager = AnyLayoutManager<DetailMovieReviewCollectionViewCell>(DetailMovieReviewLayoutManager())

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        contentView.addSubview(userImage)
        contentView.addSubview(nickname)
        contentView.addSubview(reviewText)
        contentView.addSubview(openFullReviewButton)
        layoutManager.applyLayout(for: self, bounds: bounds)
    }
}
