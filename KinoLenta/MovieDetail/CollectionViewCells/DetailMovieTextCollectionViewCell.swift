//
//  MovieTextItemCollectionViewCell.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 11.12.2021.
//

import UIKit

final class DetailMovieTextCollectionViewCell: UICollectionViewCell {
    let title: UILabel = {
        let label = UILabel()
        return label
    }()

    private let layoutManager = AnyLayoutManager<DetailMovieTextCollectionViewCell>(DetailMovieTextLayoutManager())

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutManager.applyLayout(for: self, bounds: bounds)
    }
}
