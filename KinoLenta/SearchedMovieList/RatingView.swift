//
//  RatingImageView.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 09.12.2021.
//

import UIKit

final class RatingView: UIView {
    
    var rating: UInt? {
        didSet {
            guard let rating = rating else {
                return
            }
            
            let newColor: UIColor
            switch rating {
            case 0...4:
                newColor = .red
            case 4...6:
                newColor = .yellow
            case 6...10:
                newColor = .green
            default:
                newColor = .green
            }
//            ratingLabel.text = "\(rating)"
//            ratingView.backgroundColor = newColor
        }
    }
    
    @IBOutlet private var ratingView: UIView!
}
