//
//  SearchedMoviesViewController.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 09.12.2021.
//

import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

final class SearchedMoviesViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet private var placeHolderView: UIView!
    @IBOutlet private var moviesTableView: UITableView!
    @IBOutlet var filterButton: UIButton! {
        didSet {
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .medium)
            let largeBoldDoc = UIImage(systemName: "line.3.horizontal.decrease.circle.fill", withConfiguration: largeConfig)
            filterButton.setImage(largeBoldDoc, for: .normal)
        }
    }

    @IBOutlet var searchTextField: UITextField! {
        didSet {
            searchTextField.layer.borderWidth = 1
            searchTextField.setLeftPaddingPoints(10)
            searchTextField.layer.borderColor = UIColor.pickerItemBackground.cgColor
        }
    }

    private var collectionView: QuickItemFilterView!
    private var internalCoordinator: Coordinator?
    private var displayedItems: [SearchedMovieViewItem] = []
    private var timer: Timer?
    private var cancellation: CancellationHandle?
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    var filterItems = [QuickItem]()
    var coordinator: Coordinator? {
        get {
            assert(internalCoordinator != nil)
            return internalCoordinator
        }
        set { internalCoordinator = newValue }
    }

    @IBOutlet private var searchView: UIView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    var cacheService: CacheService!
    var networkService: NetworkingService!

    @IBOutlet var searchViewTopConstraint: NSLayoutConstraint!
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.25,
                             target: self,
                             selector: #selector(findMovies),
                             userInfo: nil,
                             repeats: false)
    }

    @objc
    func findMovies() {
        cancellation?.cancel()
        cancellation = networkService.search(
            query: searchTextField.text ?? ""
        ) { [weak self] result in
            assert(Thread.isMainThread)
            guard let result = result else {
                print("Failed to search movies")
                return
            }
            self?.displayedItems = result.toSearchedMovieViewItems()
            self?.moviesTableView.reloadData()
        }
    }

    func setDisplayedItems(queryResults: [SearchedMovieViewItem]) {
        assert(Thread.isMainThread)
        displayedItems = queryResults
        moviesTableView.reloadData()
    }

    private var savedMovieIds: Set<Int> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.layer.cornerRadius = 20
        moviesTableView.backgroundColor = .mainBackground
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        searchTextField.layer.cornerRadius = floor(searchTextField.frame.height / 2)
        moviesTableView.register(UINib(nibName: Consts.nibFile, bundle: nil), forCellReuseIdentifier: Consts.cellIdentifier)
        collectionView = QuickItemFilterView(frame: placeHolderView.bounds)
        collectionView.delegate = self
        placeHolderView.addSubview(collectionView)

//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
//        self.moviesTableView.addGestureRecognizer(tapGesture)

        cacheService.getSavedMovies(option: .wishToWatch, completion: { [weak self] result in
            if case .success(let movies) = result {
                self?.savedMovieIds = Set(movies.map { $0.id })
            }
        })

        filterItems = GenreDecoderContainer.sharedMovieManager.getGenreNames().map {
            QuickItem(title: $0)
        }
        collectionView.items = filterItems
    }

    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchTextField.resignFirstResponder()
    }

    @IBAction func filterButtonPressed(_ sender: UIButton) {
        let filterScreenViewController = FilterScreenViewController()
        filterScreenViewController.delegate = self
        present(filterScreenViewController, animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: collectionView.frame.minX,
                                      y: collectionView.frame.minY,
                                      width: view.frame.width,
                                      height: collectionView.frame.height)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc
    private func watchLaterButtonPressed(_ button: SelectedButton) {
        let movie = displayedItems[button.index]

        _ = networkService.getById(movie.id, callback: { [weak self] model in
            guard let model = model else {
                print("Failed to get movie model for id: \(movie.id)")
                return
            }
            if button.isButtonSelected {
                self?.savedMovieIds.insert(movie.id)
                self?.cacheService.saveMovies([model], folderType: .wishToWatch, completion: nil)
            } else {
                self?.savedMovieIds.remove(movie.id)
                self?.cacheService.removeMovies([model], directoryType: .wishToWatch, completion: nil)
            }
        })

        button.isButtonSelected = !button.isButtonSelected
        updateWatchLaterButtonTitle(button)
    }

    private func updateWatchLaterButtonTitle(_ button: SelectedButton) {
        button.setTitle(
            button.isButtonSelected ? addedToWishlistButtonTitle : addToWishlistButtonTitle,
            for: .normal
        )
    }
}

extension SearchedMoviesViewController: FilterScreenDelegate {
    func filterChosen(_ filters: FilterFields) {
        cancellation?.cancel()
        let genre = GenreDecoderContainer.sharedMovieManager.getByName(filters.genre?.lowercased() ?? "").map { [$0] }
        if let index = filterItems.firstIndex(where: { $0.title == filters.genre ?? "" }) {
            let before = filterItems[index]
            filterItems[index] = QuickItem(isSelected: true, title: before.title)
            collectionView.collectionView.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .init())
            collectionView.collectionView.delegate?.collectionView?(collectionView.collectionView,
                                                                     didSelectItemAt: IndexPath(row: index, section: 0))
        }
        cancellation = networkService.discover(
            genre: genre,
            yearRange: filters.years?.first,
            ratingGTE: Int(filters.rating ?? 0),
            country: filters.country
        ) { [weak self] movies in
            assert(Thread.isMainThread)
            guard let movies = movies else {
                print("Failed to discover movies")
                return
            }

            self?.displayedItems = movies.toSearchedMovieViewItems()
            self?.moviesTableView.reloadData()
        }
    }
}

extension SearchedMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let id = displayedItems[indexPath.row].id
        coordinator?.openDetailMovie(withMovieId: id, context: self) { [weak self] in
            self?.cacheService.getSavedMovies(option: .wishToWatch, completion: { [weak self] result in
                if case .success(let movies) = result {
                    self?.savedMovieIds = Set(movies.map { $0.id })
                    DispatchQueue.main.async {
                        self?.moviesTableView.reloadData()
                    }
                }
            })
        }
    }
}

extension SearchedMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Consts.cellIdentifier, for: indexPath) as? SearchedMovieTableViewCell else { fatalError("Invalid cell type") }
        let movie = displayedItems[indexPath.row]

        cell.backgroundColor = .mainBackground
        cell.movieTitle.text = movie.title
        cell.movieGenre.text = movie.genre
        cell.movieDescription.text = movie.description
        guard let url = URL(string: movie.image ?? "") else {
            return UITableViewCell()
        }
        cell.ratingView.setImage(url: url)
        cell.ratingView.rating = movie.rating
        cell.ratingView.layer.cornerRadius = 10
        if savedMovieIds.contains(where: { $0 == movie.id }) {
            cell.watchLaterButton.isButtonSelected = true
        }

        updateWatchLaterButtonTitle(cell.watchLaterButton)
        cell.watchLaterButton.addTarget(self, action: #selector(watchLaterButtonPressed(_:)), for: .touchUpInside)
        cell.watchLaterButton.index = indexPath.row
        return cell
    }
}

extension SearchedMoviesViewController: QuickItemFilterDelegate {
    func itemPressed(transition: Transition, isSelected: Bool) {
        cancellation?.cancel()

        let searchViewTopConstraintNewConstant: CGFloat
        let searchViewBottomConstraintNewConstant: CGFloat
        if isSelected {
            let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
            searchViewTopConstraintNewConstant = -self.searchView.frame.height - safeAreaHeight
            searchViewBottomConstraintNewConstant = safeAreaHeight + 5
        } else {
            searchViewTopConstraintNewConstant = Consts.topSearchViewConstant
            searchViewBottomConstraintNewConstant = 10
        }
        // TODO: костыль
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.searchViewTopConstraint.constant = searchViewTopConstraintNewConstant
            self.bottomConstraint.constant = searchViewBottomConstraintNewConstant
            self.view.layoutIfNeeded()
        }

        guard isSelected else {
            displayedItems.removeAll()
            moviesTableView.reloadData()
            return
        }

        let genreIndex: Int
        switch transition {
        case .singlePress(let index):
            genreIndex = index
        case .transitionPress(_, let index):
            genreIndex = index
        }

        let genreName = filterItems[genreIndex].title.lowercased()
        if let id = GenreDecoderContainer.sharedMovieManager.getByName(genreName) {
            cancellation = networkService.discover(
                genre: [id],
                yearRange: nil,
                ratingGTE: nil,
                country: nil
            ) { [weak self] model in
                assert(Thread.isMainThread)
                guard let model = model else {
                    print("Failed to discover movies")
                    return
                }
                self?.displayedItems = model.toSearchedMovieViewItems()
                self?.moviesTableView.reloadData()
            }
        }
    }
}

extension SearchedMoviesViewController {
    private enum Consts {
        static let cellIdentifier = String(describing: SearchedMovieTableViewCell.self)
        static let nibFile = "SearchedMovieTableViewCell"
        static let topSearchViewConstant: CGFloat = 20
    }
}

final class SelectedButton: UIButton {
    var isButtonSelected: Bool = false
    var index: Int = 0
}

private let addToWishlistButtonTitle =
    NSLocalizedString("add_to_wishlist_action",
                      comment: "Action title for adding to wishlist")
private let addedToWishlistButtonTitle =
    NSLocalizedString("add_to_wishlist_action_already_added",
                      comment: "Action title for adding to wishlist in inactive state (already added)")
