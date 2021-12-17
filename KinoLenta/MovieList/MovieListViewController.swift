//
//  ViewController.swift
//  Project10
//
//  Created by Mikhail Kuimov on 09.12.2021.
//

import UIKit

class MovieListViewController: UIViewController {
    
    private var internalCoordinator: Coordinator?
    var coordinator: Coordinator? {
        get {
            assert(internalCoordinator != nil)
            return internalCoordinator
        }
        set { internalCoordinator = newValue }
    }
    
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
        
        watchedButton.layer.cornerRadius = Constants.buttonCornerRadius
        watchButton.layer.cornerRadius = Constants.buttonCornerRadius
        watchButton.clipsToBounds = true
        watchedButton.clipsToBounds = true
        self.watchButton.tintColor = Constants.selectedItemColor
        self.watchedButton.tintColor = Constants.backGroundColor
        self.watchedButton.setTitleColor(Constants.selectedItemColor, for: .normal)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let cvWidth = collectionView.bounds.width
        let cellWidth: CGFloat = Constants.isLandscape ? Constants.defaultCellWidth : min(floor(cvWidth / 2), Constants.defaultCellWidth)
        let cellPadding: CGFloat = Constants.isLandscape ? (cvWidth - floor(cvWidth / Constants.defaultCellWidth) * Constants.defaultCellWidth) / 2 : (cvWidth - cellWidth * 2) / 2
        collectionView.contentInset.left = cellPadding
        collectionView.contentInset.right = cellPadding
    }
    

    @objc func selectWatchButton() {
        self.showRating = false
        watchButton.changeState(on: .selected)
        watchedButton.changeState(on: .notSelected)
        refreshView()
    }
    
    @objc func selectWatchedButton() {
        self.showRating = true
        watchedButton.changeState(on: .selected)
        watchButton.changeState(on: .notSelected)
        refreshView()
    }
    
    private func refreshView() {
        let indices = self.collectionView.indexPathsForVisibleItems
        self.collectionView.reloadItems(at: indices)
        //temporary lines
        self.images.shuffle()
        self.collectionView.reloadData()
    }

}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cvWidth = collectionView.bounds.width
        let cellWidth: CGFloat = Constants.isLandscape ? Constants.defaultCellWidth : min(floor(cvWidth / 2), Constants.defaultCellWidth)
        return .init(width: cellWidth, height: Constants.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        #warning("Need to pass movieID")
        coordinator?.openDetailMovie(withMovieId: 0, context: self)
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseId, for: indexPath)
        
        guard let cell = cell as? PosterCell else {
            fatalError("Unable to dequeue PosterCell.")
        }
        
        let image = images[indexPath.row]
        let ratingText = ratings[indexPath.row]
        
        cell.ratingView.image = image
        cell.layer.cornerRadius = Constants.cellCornerRadius
        cell.ratingView.rating = Double(ratingText)
        cell.ratingView.ratingView.isHidden = !showRating
        return cell
    }
}

extension UIButton {
    
    enum ButtonState {
        case selected
        case notSelected
    }
    
    func changeState(on buttonState: ButtonState) {
        switch buttonState {
        case .selected:
            self.tintColor = Constants.selectedItemColor
            self.setTitleColor(.white, for: .normal)
        case .notSelected:
            self.tintColor = Constants.backGroundColor
            self.setTitleColor(Constants.selectedItemColor, for: .normal)
        }
    }
}

