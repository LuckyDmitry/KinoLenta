import Foundation
import UIKit

final class CarouselCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 10
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var ratingLabel: UILabel!
    
    func setRating(rating: Double) {
        ratingLabel.text = String(rating)
        
        switch rating {
        case 0..<4:
            ratingLabel.backgroundColor = .redRating
        case 4..<7:
            ratingLabel.backgroundColor = .yellowRating
        case 7...10:
            ratingLabel.backgroundColor = .greenRating
        default:
            return
        }
    }
}
