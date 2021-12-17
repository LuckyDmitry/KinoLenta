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
    @IBAction func onSearchButtonTap(_ sender: Any) {
        coordinator.openFilterWindow(context: self)
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
