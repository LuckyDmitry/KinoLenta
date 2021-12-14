import Foundation
import UIKit

struct CarouselData {
    let image: UIImage?
    let text: String
}

final class MovieSampleTableCell: UITableViewCell, BaseTableViewCell {
    
    @IBOutlet weak var sampleTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.showsHorizontalScrollIndicator = false
//            collectionView.dataSource = self
//            collectionView.delegate = self
            collectionView.backgroundColor = .clear
        }
    }
    
    @IBAction func showAllAction(_ sender: Any) {
        
    }
    var carouselData: [CarouselData] = []

}

//extension MovieSampleTableCell: UICollectionViewDataSource, UICollectionViewDelegate {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return carouselData.count
//    }
//    
////    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieSampleTableCell.cellId, for: indexPath) as? MovieSampleTableCell else { return UICollectionViewCell() }
////
////        let image = carouselData[indexPath.row].image
////        let text = carouselData[indexPath.row].text
////
////        cell.configure(image: image, text: text)
////
////        return cell
////    }
//}
