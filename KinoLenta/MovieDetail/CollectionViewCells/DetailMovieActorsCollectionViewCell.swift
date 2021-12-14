//
//  DetailMovieActorsCollectionViewCell.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 11.12.2021.
//

import UIKit

final class DetailMovieActorsCollectionViewCell: UICollectionViewCell {
    let primaryLabel = UILabel()
    let secondaryLabel = UILabel()
    
    private let layoutManager = AnyLayoutManager<DetailMovieActorsCollectionViewCell>(DetailMovieActorsLayoutManager())

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(primaryLabel)
        contentView.addSubview(secondaryLabel)
        secondaryLabel.numberOfLines = 0
        primaryLabel.numberOfLines = 0
        
        layoutManager.applyLayout(for: self, bounds: bounds)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
