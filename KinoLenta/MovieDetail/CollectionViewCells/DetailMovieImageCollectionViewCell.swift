//
//  DetailMovieImageItemCollectionViewCell.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 11.12.2021.
//

import UIKit

final class DetailMovieImageCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    var cancellation: CancellationHandle?

    var insets: UIEdgeInsets = .zero

    private let layoutManager = AnyLayoutManager<DetailMovieImageCollectionViewCell>(DetailMovieImageLayoutManager())

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutManager.applyLayout(for: self, bounds: bounds.inset(by: insets))
    }
}
