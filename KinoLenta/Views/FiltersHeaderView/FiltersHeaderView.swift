import Foundation
import UIKit

protocol CloseScreenDelegate: AnyObject {
    func closeScreen()
}

final class FiltersHeaderView: UIView {
    weak var delegate: CloseScreenDelegate?

    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = NSLocalizedString("filter_screen_title", comment: "Title of filters screen")
        }
    }

    @IBAction private func closeScreenAction(_ sender: Any) {
        delegate?.closeScreen()
    }
}
