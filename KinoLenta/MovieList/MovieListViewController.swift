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

    @IBOutlet var watchButton: UIButton! {
        didSet {
            watchButton.setTitle(
                NSLocalizedString(
                    "favorites_screen_wishlist_switcher_title",
                    comment: "Wishlist switcher state title on favorites screen"
                ),
                for: .normal
            )
        }
    }

    @IBOutlet var watchedButton: UIButton! {
        didSet {
            watchedButton.setTitle(
                NSLocalizedString(
                    "favorites_screen_watched_list_switcher_title",
                    comment: "Already watched list switcher state title on favorites screen"
                ),
                for: .normal
            )
        }
    }

    @IBOutlet var placeHolderView: UIView!
    @IBOutlet var collectionView: UICollectionView!

    var cacheService: CacheService!
    var showRating: Bool = false

    var movieModels: [MovieDomainModel] = []

    var movieOption: SavedMovieOption = .wishToWatch {
        didSet {
            loadMovies()
        }
    }

    private func loadMovies() {
        cacheService.getSavedMovies(option: movieOption, completion: { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let movies):
                    self?.movieModels = movies
                    self?.collectionView.reloadData()
                case .failure(_):
                    break
                }
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        watchButton.addTarget(
            self,
            action: #selector(selectWatchButton),
            for: .touchUpInside
        )

        watchedButton.addTarget(
            self,
            action: #selector(selectWatchedButton),
            for: .touchUpInside
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        watchedButton.layer.cornerRadius = Constants.buttonCornerRadius
        watchButton.layer.cornerRadius = Constants.buttonCornerRadius
        watchButton.clipsToBounds = true
        watchedButton.clipsToBounds = true
        self.watchButton.tintColor = .pickerItemBackground
        self.watchedButton.tintColor = .mainBackground
        self.watchButton.setTitleColor(.buttonTextColor, for: .normal)
        self.watchedButton.setTitleColor(.pickerItemBackground, for: .normal)
        loadMovies()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let cvWidth = collectionView.bounds.width
        let cellWidth: CGFloat = Constants.isLandscape ? Constants.defaultCellWidth : min(
            floor(cvWidth / 2),
            Constants.defaultCellWidth
        )
        let cellPadding: CGFloat = Constants
            .isLandscape ? (cvWidth - floor(cvWidth / Constants.defaultCellWidth) * Constants.defaultCellWidth) / 2 :
            (cvWidth - cellWidth * 2) / 2
        collectionView.contentInset.left = cellPadding
        collectionView.contentInset.right = cellPadding
    }


    @objc func selectWatchButton() {
        self.showRating = false
        watchButton.changeState(to: .selected)
        watchedButton.changeState(to: .notSelected)
        refreshView()
        movieOption = .wishToWatch
    }

    @objc func selectWatchedButton() {
        self.showRating = true
        watchedButton.changeState(to: .selected)
        watchButton.changeState(to: .notSelected)
        refreshView()
        movieOption = .watched
    }

    private func refreshView() {
//        let indices = self.collectionView.indexPathsForVisibleItems
//        self.collectionView.reloadItems(at: indices)
        // temporary lines
//        self.images.shuffle()
//        self.collectionView.reloadData()
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cvWidth = collectionView.bounds.width
        let cellWidth: CGFloat = Constants.isLandscape ? Constants.defaultCellWidth : min(
            floor(cvWidth / 2),
            Constants.defaultCellWidth
        )
        return .init(width: cellWidth, height: Constants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.didSelectMovie(model: movieModels[indexPath.row])
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieModels.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: Constants.reuseId, for: indexPath) as? PosterCell
        else {
            fatalError("Invalid cell type")
        }

        let model = movieModels[indexPath.row]
        if let url = model.backdropURL {
            cell.ratingView.setImage(url: url)
        }
        cell.layer.cornerRadius = Constants.cellCornerRadius
        cell.ratingView.ratingView.isHidden = !showRating
        return cell
    }
}

extension UIButton {
    enum ButtonState {
        case selected
        case notSelected
    }

    func changeState(to buttonState: ButtonState) {
        switch buttonState {
        case .selected:
            self.tintColor = .pickerItemBackground
            self.setTitleColor(.buttonTextColor, for: .normal)
        case .notSelected:
            self.tintColor = .mainBackground
            self.setTitleColor(.pickerItemBackground, for: .normal)
        }
    }
}

