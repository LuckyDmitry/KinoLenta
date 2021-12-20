import Foundation
import UIKit

final class MoviesSamplingViewController: UIViewController {
    
    var coordinator: Coordinator!
    
    var dataProvider: NetworkingService!
        
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
            let largeBoldDoc = UIImage.magnifyingGlass?.withConfiguration(largeConfig)
            searchButton.setImage(largeBoldDoc, for: .normal)
        }
    }
    @IBAction func onSearchButtonTap(_ sender: Any) {
        coordinator.openSearchWindow()
    }
}


extension MoviesSamplingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return (tableView.dequeueReusableCell(
                withIdentifier: "MovieSampleTableCell",
                for: indexPath
            ) as! MovieSampleTableCell).configured { cell in
                cell.sampleTitle.text = "В тренде"
                cell.contextVC = self
                dataProvider.getTrending { data in
                    cell.originalItems = data
                    cell.items = data.toCarouselData()
                    cell.reloadData()
                }
                cell.coordinator = coordinator
            }
        case 1:
            return (tableView.dequeueReusableCell(
                withIdentifier: "MovieSampleTableCell",
                for: indexPath
            ) as! MovieSampleTableCell).configured { cell in
                cell.sampleTitle.text = "Популярное"
                cell.contextVC = self
                dataProvider.getPopular { data in
                    cell.originalItems = data
                    cell.items = data.toCarouselData()
                    cell.reloadData()
                }
                cell.coordinator = coordinator
            }
        case 2:
            return (tableView.dequeueReusableCell(
                withIdentifier: "MovieSampleTableCell",
                for: indexPath
            ) as! MovieSampleTableCell).configured { cell in
                cell.sampleTitle.text = "Лучшее"
                cell.contextVC = self
                dataProvider.getTopRated { data in
                    cell.originalItems = data
                    cell.items = data.toCarouselData()
                    cell.reloadData()
                }
                cell.coordinator = coordinator
            }
        default:
            return UITableViewCell()
            
        }
    }
}

