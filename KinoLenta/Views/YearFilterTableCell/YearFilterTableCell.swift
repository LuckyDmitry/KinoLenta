import Foundation
import UIKit

final class YearFilterTableCell: UITableViewCell, BaseTableViewCell {
        
    weak var delegate: UpdateTableDelegate?

    @IBOutlet private weak var datePicker: UIPickerView! {
        didSet {
            datePicker.delegate = self
            datePicker.dataSource = self
        }
    }
    
    @IBOutlet private weak var datePickerHeight: NSLayoutConstraint!
    @IBOutlet private weak var dateButton: UIButton!
    
    @IBAction private func showPickerAction(_ sender: Any) {
        
        UIView.animate(
            withDuration: 0.4,
            animations: { [weak self] in
                guard let self = self else { return }
                self.datePickerHeight.constant = self.isPickerShowing ? 0 : 100
                self.datePicker.isHidden = self.isPickerShowing
                
                self.isPickerShowing.toggle()
                self.layoutIfNeeded()
                
                self.delegate?.reloadTableView()
            }
        )
        layoutIfNeeded()
    }
        
    private let allYears = Array(1950...2021)
    private var isPickerShowing = false
    
    func reset() {
        delegate = nil
    }
}

extension YearFilterTableCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        allYears.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row < allYears.count else { return assertionFailure() }
        let fromDate = pickerView.selectedRow(inComponent: 0)
        let toDate = pickerView.selectedRow(inComponent: 1)
        
        dateButton.setTitle("от \(allYears[fromDate]) до \(allYears[toDate])", for: .normal)
        
        dateButton.setTitleColor(
            allYears[fromDate] > allYears[toDate]
            ? .red
            : UIColor(named: "OrangeDarkColor"),
            for: .normal
        )
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard row < allYears.count else {
            assertionFailure()
            return nil
        }
        return "\(allYears[row])"
    }
}

extension YearFilterTableCell {
    func configured(action: (YearFilterTableCell) -> Void) -> YearFilterTableCell {
        action(self)
        return self
    }
}
