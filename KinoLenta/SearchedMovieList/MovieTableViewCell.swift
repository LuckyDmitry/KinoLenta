//
//  MovieTableViewCell.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 09.12.2021.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var watchLaterButton: UIButton!
    @IBOutlet var movieDescription: UILabel!
    @IBOutlet var movieGenre: UILabel!
    @IBOutlet var ratingView: RatingView!
    @IBOutlet var posterImageView: UIImageView!
}
