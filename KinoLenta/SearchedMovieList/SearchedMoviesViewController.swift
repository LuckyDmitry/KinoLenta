//
//  SearchedMoviesViewController.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 09.12.2021.
//

import UIKit

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
            searchTextField.layer.borderColor = UIColor.pickerItemBackground.cgColor
        }
    }
    private var collectionView: QuickItemFilterView!
    private var internalCoordinator: Coordinator?
    private var displayedItems: [SearchedMovieViewItem] = []
    private var timer: Timer?
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
        let request = searchTextField.text ?? ""
        networkService.search(query: request, callback: { [weak self] res in
            DispatchQueue.main.async { [weak self] in
                self?.displayedItems = res.toSearchedMovieViewItems()
                self?.moviesTableView.reloadData()
                self?.timer = nil
            }
        })
    }
    
    func setDisplayedItems(queryResults: [SearchedMovieViewItem]) {
        displayedItems = queryResults
        DispatchQueue.main.async { [self]
            self.moviesTableView.reloadData()
        }
        
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

    @IBAction func filterButtonPressed(_ sender: UIButton) {
        let filterScreenViewController = FilterScreenViewController()
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
        let title = button.isButtonSelected ? "Смотреть позже" : "Добавлено" 
        let movie = displayedItems[button.index]
        
        networkService.getById(movie.id, callback: { [weak self] model in
            if button.isButtonSelected {
                self?.savedMovieIds.insert(movie.id)
                self?.cacheService.saveMovies([model], folderType: .wishToWatch, completion: nil)
            } else {
                self?.savedMovieIds.remove(movie.id)
                self?.cacheService.removeMovies([model], directoryType: .wishToWatch, completion: nil)
            }
        })
       
        button.setTitle(title, for: .normal)
        button.isButtonSelected = !button.isButtonSelected
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
        
        cell.watchLaterButton.setTitle(cell.watchLaterButton.isButtonSelected ? "Добавлено" :
                                        "Смотреть позже", for: .normal)
        cell.watchLaterButton.addTarget(self, action: #selector(watchLaterButtonPressed(_:)), for: .touchUpInside)
        cell.watchLaterButton.index = indexPath.row
        return cell
    }
}

extension SearchedMoviesViewController: QuickItemFilterDelegate {
    func itemPressed(transition: Transition, isSelected: Bool) {
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
            networkService.discover(genre: [id], yearRange: nil, ratingGTE: nil, country: nil, callback: { model in
                DispatchQueue.main.async { [weak self] in
                    self?.displayedItems = model.toSearchedMovieViewItems()
                    self?.moviesTableView.reloadData()
                }
            })
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

