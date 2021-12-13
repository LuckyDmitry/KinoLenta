import Foundation
import UIKit

final class RatingFilterTableCell: UITableViewCell, BaseTableViewCell {
    
    weak var delegate: UpdateTableDelegate?
    var isSliderShowing = false
    
    @IBOutlet private weak var valueButton: UIButton!
    @IBOutlet private weak var ratingSlider: UISlider! {
        didSet {
            ratingSlider.setValue(5, animated: false)
            ratingSlider.isHidden = true
        }
    }
    
    @IBAction func raitingSliderAction(_ sender: Any) {
        let value = Int(round(ratingSlider.value))
        let text = String(repeating: "★", count: value) +  String(repeating: "☆", count: 10 - value)
        
        valueButton.setTitle(text, for: .normal)
        valueButton.setTitleColor(UIColor(named: "OrangeDarkColor"), for: .normal)
    }
    
    @IBOutlet weak var sliderHeight: NSLayoutConstraint!
    @IBOutlet weak var sliderTopConstraint: NSLayoutConstraint!
    
    @IBAction func showSliderAction(_ sender: Any) {
        
        UIView.animate(
            withDuration: 0.4,
            animations: { [weak self] in
                guard let self = self else { return }
                self.sliderHeight.constant = self.isSliderShowing ? 0 : 30
                self.sliderTopConstraint.constant = self.isSliderShowing ? 0 : 35
                self.ratingSlider.isHidden = self.isSliderShowing
                
                self.isSliderShowing.toggle()
                self.layoutIfNeeded()
                
                self.delegate?.reloadTableView()
            }
        )
        layoutIfNeeded()
    }
    
    func reset() {
        delegate = nil
    }
}

extension RatingFilterTableCell {
    func configured(action: (RatingFilterTableCell) -> Void) -> RatingFilterTableCell {
        action(self)
        return self
    }
}
