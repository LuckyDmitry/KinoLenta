import Foundation
import UIKit

struct CarouselData {
    let id: Int
    let image: URL?
    let rating: Double?
    let name: String?
}

final class MovieSampleTableCell: UITableViewCell, BaseTableViewCell {
    var contextVC: UIViewController!
    var coordinator: Coordinator!
    var originalItems: [QueryMovieModel] = []
    var items: [CarouselData] = []
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    @IBOutlet weak var sampleTitle: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            collectionView.register(UINib(nibName: Consts.cellDescribing, bundle: nil), forCellWithReuseIdentifier: Consts.cellDescribing)
        }
    }

    @IBOutlet private weak var showAllButton: UIButton! {
        didSet {
            showAllButton.setTitle(
                NSLocalizedString("featured_screen_show_all_action",
                                  comment: "Show all movies in collection action title on featured movies screen"),
                for: .normal
            )
        }
    }

    @IBAction private func showAllAction(_ sender: Any) {
        coordinator.openSearchWindow(context: contextVC, movies: originalItems)
    }
}


extension MovieSampleTableCell {
    private enum Consts {
        static let cellDescribing = String(describing: CarouselCollectionCell.self)
        static let marginBetweenCells: CGFloat = 20
        static let padding: CGFloat = 5
    }
}

extension MovieSampleTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (bounds.width - 2 * Consts.padding - Consts.marginBetweenCells) / 2
        let height = self.collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
}

extension MovieSampleTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Consts.cellDescribing, for: indexPath)
        guard let cell = cell as? CarouselCollectionCell else { fatalError("Invalid cell type") }
        
        cell.reset()
        
        let item = items[indexPath.row]
        cell.movieTitle.text = item.name
        cell.ratingView.rating = item.rating
        if let url = item.image {
            cell.ratingView.setImage(url: url)
        }
        return cell
    }
}

extension MovieSampleTableCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieId = items[indexPath.row]
        coordinator.openDetailMovie(withMovieId: movieId.id, context: contextVC) {}
    }
}

extension MovieSampleTableCell {
    func configured(action: (MovieSampleTableCell) -> Void) -> MovieSampleTableCell {
        action(self)
        return self
    }
}
