//
//  PosterCell.swift
//  Project10
//
//  Created by Mikhail Kuimov on 10.12.2021.
//

import UIKit

class PosterCell: UICollectionViewCell {
    @IBOutlet var ratingView: RatingView! {
        didSet {
            ratingView.reset()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        ratingView.reset()
    }
}
