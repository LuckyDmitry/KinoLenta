import Foundation
import UIKit

final class MoviesSamplingViewController: UIViewController {
    
    var coordinator: Coordinator!
        
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(MovieSampleTableCell.self)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet var searchButton: UIButton! {
        didSet {
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .medium)
            let largeBoldDoc = UIImage(systemName: "magnifyingglass", withConfiguration: largeConfig)
            searchButton.setImage(largeBoldDoc, for: .normal)
        }
    }
    @IBAction func onSearchButtonTap(_ sender: Any) {
        coordinator.openSearchWindow()
    }
}

#warning("mock data")
extension MoviesSamplingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0...4:
            return (tableView.dequeueReusableCell(
                withIdentifier: "MovieSampleTableCell",
                for: indexPath
            ) as! MovieSampleTableCell).configured { cell in
                cell.sampleTitle.text = "Лучшее"
                cell.contextVC = self
                cell.coordinator = coordinator
            }
        default:
            return UITableViewCell()
            
        }
    }
}
