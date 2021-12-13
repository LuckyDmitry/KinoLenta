//
//  ViewController.swift
//  Project10
//
//  Created by Mikhail Kuimov on 09.12.2021.
//

import UIKit

class MovieListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var watchButton: UIButton!
    @IBOutlet var watchedButton: UIButton!
    @IBOutlet var placeHolderView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    var images = (0...11).compactMap { number -> UIImage? in
        let image = UIImage(named: "poster\(number)")
        return image
    }
    
    var ratings = (0...11).compactMap { number -> Int in
        return Int.random(in: 1...5)
    }
    
    var showRating: Bool = false
    
    private enum Constants {
        static let reuseId: String = String(describing: PosterCell.self)
        static var isLandscape: Bool { UIDevice.current.orientation.isLandscape }
        static let backGroundColor: UIColor = UIColor(named: "mainBackground") ?? .white
        static let seletctedItemColor: UIColor = UIColor(named: "selectedItemBackground") ?? .black
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        watchButton.addTarget(
            self,
            action: #selector(selectWatchButton),
            for: .touchUpInside)
        
        watchedButton.addTarget(
            self,
            action: #selector(selectWatchedButton),
            for: .touchUpInside)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        watchedButton.layer.cornerRadius = 10
        watchButton.layer.cornerRadius = 10
        watchButton.clipsToBounds = true
        watchedButton.clipsToBounds = true
        self.watchButton.tintColor = Constants.seletctedItemColor
        self.watchedButton.tintColor = Constants.backGroundColor
        self.watchedButton.setTitleColor(Constants.seletctedItemColor, for: .normal)
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
        let ratingText = ratings[indexPath.row]
        
        cell.ratingView.image = image
        cell.layer.cornerRadius = 5
        
        cell.ratingView.rating = Double(ratingText)
        
        cell.ratingView.ratingView.isHidden = !showRating
        return cell
    }

    @objc func selectWatchButton() {
        self.showRating = false
        self.watchButton.tintColor = Constants.seletctedItemColor
        self.watchButton.setTitleColor(.white, for: .normal)
        self.watchedButton.tintColor = Constants.backGroundColor
        self.watchedButton.setTitleColor(Constants.seletctedItemColor, for: .normal)
        let indices = self.collectionView.indexPathsForVisibleItems
        self.collectionView.reloadItems(at: indices)
        
        self.images.shuffle()
        self.collectionView.reloadData()
    }
    
    @objc func selectWatchedButton() {
        self.showRating = true
        self.watchedButton.tintColor = Constants.seletctedItemColor
        self.watchedButton.setTitleColor(.white, for: .normal)
        self.watchButton.tintColor = Constants.backGroundColor
        self.watchButton.setTitleColor(Constants.seletctedItemColor, for: .normal)
        let indices = self.collectionView.indexPathsForVisibleItems
        self.collectionView.reloadItems(at: indices)
        self.images.shuffle()
        self.collectionView.reloadData()
        
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

