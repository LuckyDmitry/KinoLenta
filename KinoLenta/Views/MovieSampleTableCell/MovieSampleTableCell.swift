import Foundation
import UIKit

struct CarouselData {
    let image: URL?
    let rating: Double?
    let name: String?
}

final class MovieSampleTableCell: UITableViewCell, BaseTableViewCell {
    
    var contextVC: UIViewController!
    var coordinator: Coordinator!
    
    @IBOutlet weak var sampleTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
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
    
    @IBAction func showAllAction(_ sender: Any) {
//        TODO: open movies screen
    }
    
    // TODO: Will be removed
    private var items: [CarouselData] = [
        CarouselData(
            image: nil,
            rating: 7,
            name: "Название"
        ),
        CarouselData(
            image: URL(string: "https://miro.medium.com/max/1400/1*mtGIfXRPG2FG_zbKJhwWzA.png"),
            rating: 5,
            name: "Название"
        ),
        CarouselData(
            image: URL(string: "https://miro.medium.com/max/1400/1*mtGIfXRPG2FG_zbKJhwWzA.png"),
            rating: 9,
            name: "Название"
        ),
        CarouselData(
            image: URL(string: "https://miro.medium.com/max/1400/1*mtGIfXRPG2FG_zbKJhwWzA.png"),
            rating: 3,
            name: "Название"
        )]
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
//        TODO: open here movie detail screen
        #warning("need to pass movieID")
        coordinator.openDetailMovie(withMovieId: 0, context: contextVC, completion: nil)
    }
}

extension MovieSampleTableCell {
    func configured(action: (MovieSampleTableCell) -> Void) -> MovieSampleTableCell {
        action(self)
        return self
    }
}
