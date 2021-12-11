//
//  MovieTextItemCollectionViewCell.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 11.12.2021.
//

import UIKit

final class MovieTextItemCollectionViewCell: UICollectionViewCell {
    var title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = bounds
    }
}
