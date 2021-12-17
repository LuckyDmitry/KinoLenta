import Foundation
import UIKit

final class CarouselCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var ratingView: RatingView! {
        didSet {
            ratingView.layer.cornerRadius = 10
            ratingView.clipsToBounds = true
        }
    }
    
    func reset() {
        movieTitle.text = nil
        ratingView.reset()
    }
}
