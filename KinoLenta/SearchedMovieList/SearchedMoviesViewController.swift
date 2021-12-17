//
//  SearchedMoviesViewController.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 09.12.2021.
//

import UIKit

final class SearchedMoviesViewController: UIViewController {
    @IBOutlet private var placeHolderView: UIView!
    @IBOutlet private var moviesTableView: UITableView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    private var collectionView: QuickItemFilterView!
    
    private var internalCoordinator: Coordinator?
    var coordinator: Coordinator? {
        get {
            assert(internalCoordinator != nil)
            return internalCoordinator
        }
        set { internalCoordinator = newValue }
    }
    
    var movies: [SearchedMovieViewItem] = []
    var filterItems = [QuickItem]()
    
    private var displayedItems: [SearchedMovieViewItem] = []
    
    func setDisplayedItems(queryResults: [SearchedMovieViewItem]) {
        displayedItems = queryResults
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.backgroundColor = .mainBackground
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        moviesTableView.register(UINib(nibName: Consts.nibFile, bundle: nil), forCellReuseIdentifier: Consts.cellIdentifier)
        collectionView = QuickItemFilterView(frame: placeHolderView.bounds)
        placeHolderView.addSubview(collectionView)
        collectionView.items = filterItems
        navigationItem.title = "Title"
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: collectionView.frame.minX,
                                      y: collectionView.frame.minY,
                                      width: view.frame.width,
                                      height: collectionView.frame.height)
    }
}

extension SearchedMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        coordinator?.openDetailMovie(withMovieId: .zero, context: self)
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
        cell.ratingView.image = movie.image
        cell.ratingView.rating = movie.rating
        cell.ratingView.layer.cornerRadius = 10
        return cell
    }
}

extension SearchedMoviesViewController {
    private enum Consts {
        static let cellIdentifier = String(describing: SearchedMovieTableViewCell.self)
        static let nibFile = "SearchedMovieTableViewCell"
    }
}

