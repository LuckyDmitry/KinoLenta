import Foundation
import UIKit

final class CarouselCollectionCell: UICollectionViewCell {
    var cancellationHandle: CancellationHandle?
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var ratingView: RatingView! {
        didSet {
            ratingView.layer.cornerRadius = 10
            ratingView.clipsToBounds = true
        }
    }
    
    func reset() {
        cancellationHandle?.isCancelled = true
        movieTitle.text = nil
        ratingView.reset()
    }
}
