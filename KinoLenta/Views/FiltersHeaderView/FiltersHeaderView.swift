import Foundation
import UIKit

protocol CloseScreenDelegate: AnyObject {
    func closeScreen()
}

final class FiltersHeaderView: UIView {
    
    weak var delegate: CloseScreenDelegate?
    
    @IBAction private func closeScreenAction(_ sender: Any) {
        delegate?.closeScreen()
    }
}
