import Foundation
import UIKit

protocol SearchMoviesWithFilterDelegate: AnyObject {
    func searchMovies()
}

final class FiltersFooterView: UIView {
    
    weak var delegate: SearchMoviesWithFilterDelegate?
    
    @IBOutlet private weak var filterButton: UIButton! {
        didSet {
            filterButton.layer.cornerRadius = 10
        }
    }
    @IBAction private func showAction(_ sender: Any) {
        delegate?.searchMovies()
    }
}
