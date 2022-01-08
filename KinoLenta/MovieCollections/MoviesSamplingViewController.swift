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
            return cell(
                in: tableView,
                forRowAt: indexPath,
                title: NSLocalizedString(
                    "featured_screen_trending_title",
                    comment: "Trending collection title on featured movies screen"
                ),
                getData: dataProvider.getTrending
            )
        case 1:
            return cell(
                in: tableView,
                forRowAt: indexPath,
                title: NSLocalizedString(
                    "featured_screen_popular_title",
                    comment: "Popular collection title on featured movies screen"
                ),
                getData: dataProvider.getPopular
            )
        case 2:
            return cell(
                in: tableView,
                forRowAt: indexPath,
                title: NSLocalizedString(
                    "featured_screen_top_rated_title",
                    comment: "Top rated collection title on featured movies screen"
                ),
                getData: dataProvider.getTopRated
            )
        default:
            return UITableViewCell()
        }
    }

    private func cell(
        in tableView: UITableView,
        forRowAt indexPath: IndexPath,
        title: String,
        getData: (@escaping ([QueryMovieModel]?) -> Void) -> CancellationHandle
    ) -> MovieSampleTableCell {
        (tableView.dequeueReusableCell(
            withIdentifier: "MovieSampleTableCell",
            for: indexPath
        ) as! MovieSampleTableCell).configured { cell in
            cell.sampleTitle.text = title
            cell.contextVC = self
            _ = getData { data in
                guard let data = data else {
                    print("Failed to get data for cell: '\(title)")
                    return
                }
                cell.originalItems = data
                cell.items = data.toCarouselData()
                cell.reloadData()
            }
            cell.coordinator = coordinator
        }
    }
}

extension Collection where Element == QueryMovieModel {
    func toCarouselData(genreSeparator: String = ", ") -> [CarouselData] {
        map {
            CarouselData(id: $0.id, image: $0.backdropURL, rating: $0.voteAverage, name: $0.title)
        }
    }
}
