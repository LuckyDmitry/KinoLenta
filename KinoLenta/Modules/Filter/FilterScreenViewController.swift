import Foundation
import UIKit

struct FilterFields {
    let genre: String?
    let country: String?
    let rating: Double?
    let years: [ClosedRange<Int>]?
}

protocol FilterScreenDelegate: AnyObject {
    func filterChosen(_ filters: FilterFields)
}

final class FilterScreenViewController: UIViewController {
    
    weak var delegate: FilterScreenDelegate?
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(RatingFilterTableCell.self)
            tableView.register(YearFilterTableCell.self)
            tableView.register(PickerFilterTableCell.self)

            tableView.tableHeaderView = headerView
            tableView.tableFooterView = footerView
            
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private lazy var headerView: FiltersHeaderView? = {
        guard let headerView = UINib(nibName: "FiltersHeaderView", bundle: nil)
                .instantiate(withOwner: nil, options: nil)[0] as? FiltersHeaderView else {
                    assertionFailure()
                    return nil
                }
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 200)
        headerView.delegate = self
        return headerView
    }()
    
    
    private lazy var footerView: FiltersFooterView? = {
        guard let footerView = UINib(nibName: "FiltersFooterView", bundle: nil)
                .instantiate(withOwner: nil, options: nil)[0] as? FiltersFooterView else {
                    assertionFailure()
                    return nil
                }
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 150)
        footerView.delegate = self
        return footerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
}

extension FilterScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return (tableView.dequeueReusableCell(
                withIdentifier: "PickerFilterTableCell",
                for: indexPath
            ) as! PickerFilterTableCell).configured { cell in
                setPickerFilterFields(
                    cell: cell,
                    titleLabel: "Жанры",
                    buttonTitle: "Не выбрано",
                    pickerData: ["Не выбрано", "Ужасы", "Комедия", "Боевик"]
                )
            }
            
        case 1:
            return (tableView.dequeueReusableCell(
                withIdentifier: "PickerFilterTableCell",
                for: indexPath
            ) as! PickerFilterTableCell).configured { cell in
                setPickerFilterFields(
                    cell: cell,
                    titleLabel: "Страна",
                    buttonTitle: "Не выбрано",
                    pickerData: ["Не выбрано", "Россия", "Сша", "Мексика"]
                )
            }
            
        case 2:
            return (tableView.dequeueReusableCell(
                withIdentifier: "YearFilterTableCell",
                for: indexPath
            ) as! YearFilterTableCell).configured { cell in
                cell.reset()
                cell.delegate = self
            }
            
        case 3:
            return (tableView.dequeueReusableCell(
                withIdentifier: "RatingFilterTableCell",
                for: indexPath
            ) as! RatingFilterTableCell).configured { cell in
                cell.reset()
                cell.delegate = self
            }
            
        default:
            return UITableViewCell()
        }
    }
}

extension FilterScreenViewController: UpdateTableDelegate {
    func reloadTableView() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension FilterScreenViewController: CloseScreenDelegate, SearchMoviesWithFilterDelegate {
    func closeScreen() {
        dismiss(animated: true)
    }
    
    func searchMovies() {
        guard let genreCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PickerFilterTableCell,
              let countryCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PickerFilterTableCell,
              let yearCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? YearFilterTableCell,
              let ratingCell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? RatingFilterTableCell else {
                  return
              }
        let filterFields = FilterFields(
            genre: genreCell.selectedField,
            country: countryCell.selectedField,
            rating: ratingCell.selectedRating,
            years: yearCell.selectedYears
        )
        delegate?.filterChosen(filterFields)
        dismiss(animated: true)
    }
}

extension FilterScreenViewController {
    
    private func setPickerFilterFields(
        cell: PickerFilterTableCell,
        titleLabel: String,
        buttonTitle: String,
        pickerData: [String]
    ) {
        cell.reset()
        cell.titleLabel.text = titleLabel
        cell.selectionButton.setTitle(buttonTitle, for: .normal)
        cell.delegate = self
        cell.pickerData = pickerData
    }
}
