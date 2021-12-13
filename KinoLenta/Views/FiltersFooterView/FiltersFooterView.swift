import Foundation
import UIKit

final class FiltersFooterView: UIView {
    
    weak var delegate: CloseScreenDelegate?
    
    @IBOutlet private weak var filterButton: UIButton! {
        didSet {
            filterButton?.layer.cornerRadius = 10
        }
    }
    @IBAction private func showAction(_ sender: Any) {
        delegate?.closeScreen()
    }
}
