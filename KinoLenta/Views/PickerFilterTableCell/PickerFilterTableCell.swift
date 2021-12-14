import Foundation
import UIKit

protocol UpdateTableDelegate: AnyObject {
    func reloadTableView()
}

final class PickerFilterTableCell: UITableViewCell, BaseTableViewCell {
    
    var pickerData: [String] = []
    weak var delegate: UpdateTableDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionButton: UIButton!
    @IBAction private func showPicker(_ sender: Any) {

        UIView.animate(
            withDuration: 0.4,
            animations: { [weak self] in
                guard let self = self else { return }
                self.variantsPickerHeight.constant = self.isPickerShowing ? 0 : 100
                self.variantsPicker.isHidden = self.isPickerShowing
                
                self.isPickerShowing.toggle()
                self.layoutIfNeeded()
                
                self.delegate?.reloadTableView()
            }
        )
        layoutIfNeeded()
    }
    @IBOutlet private weak var variantsPicker: UIPickerView! {
        didSet {
            variantsPicker.delegate = self
            variantsPicker.dataSource = self
        }
    }
    @IBOutlet private weak var variantsPickerHeight: NSLayoutConstraint!
    
    private var isPickerShowing = false
    
    func reset() {
        titleLabel.text = nil
        selectionButton.setTitle(nil, for: .normal)
        delegate = nil
        pickerData.removeAll()
    }
}

extension PickerFilterTableCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        3
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row < pickerData.count else { return assertionFailure() }
        selectionButton.setTitle(pickerData[row], for: .normal)
        selectionButton.setTitleColor(
            row == 0 ? .textPlaceholderForeground : .darkOrangeTextForeground,
            for: .normal
        )
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard row  < pickerData.count else {
            assertionFailure()
            return nil
        }
        return pickerData[row]
    }

}

extension PickerFilterTableCell {
    func configured(action: (PickerFilterTableCell) -> Void) -> PickerFilterTableCell {
        action(self)
        return self
    }
}
