//
//  ViewController.swift
//  Project10
//
//  Created by Mikhail Kuimov on 09.12.2021.
//

import UIKit

class MovieListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var images = (0...11).compactMap { number -> UIImage? in
        let image = UIImage(named: "poster\(number)")
        return image
    }
    
    var ratings = (0...11).compactMap { number -> String in
        return "\(Int.random(in: 1...5))"
    }
    
    private enum Constants {
        static let reuseId: String = String(describing: PosterCell.self)
        static var isLandscape: Bool { UIDevice.current.orientation.isLandscape }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let cvWidth = collectionView.bounds.width
        let cellWidth: CGFloat = Constants.isLandscape ? 180 : min(floor(cvWidth / 2), 180)
        print(cellWidth)
        let cellPadding: CGFloat = Constants.isLandscape ? (cvWidth - floor(cvWidth / 180) * 180) / 2 : (cvWidth - cellWidth * 2) / 2
        collectionView.contentInset.left = cellPadding
        collectionView.contentInset.right = cellPadding
        print(cellPadding, cvWidth, cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseId, for: indexPath)
        
        guard let cell = cell as? PosterCell else {
            return cell
        }
        
        let image = images[indexPath.row]
        cell.posterImage.image = image
        cell.posterImage.contentMode = .scaleAspectFill
        cell.layer.cornerRadius = 5
        
        let rating = ratings[indexPath.row]
        cell.posterRating.text = rating
        cell.posterRating.isHidden = cell.showRating
        return cell
    }


}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cvWidth = collectionView.bounds.width
        let cellWidth: CGFloat = Constants.isLandscape ? 180 : min(floor(cvWidth / 2), 180)
        return .init(width: cellWidth, height: 270)
    }
}

