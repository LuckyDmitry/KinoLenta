//
//  SearchedMoviesViewController.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 09.12.2021.
//

import UIKit

protocol SearchedMoviesView: AnyObject {
    func showMovies(_ movies: [SearchedMovieViewItem])
    func showGenres(_ genres: [QuickItem])
}

final class SearchedMoviesViewController: UIViewController {
    var presenter: (SearchedMoviePresenter & QuickItemFilterDelegate)!
    
    private lazy var moviesTableView: UITableView = {
        let moviesTableView = UITableView()
        moviesTableView.translatesAutoresizingMaskIntoConstraints = false
        moviesTableView.backgroundColor = .mainBackground
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.register(UINib(nibName: Consts.nibFile, bundle: nil), forCellReuseIdentifier: Consts.cellIdentifier)
        return moviesTableView
    }()
    
    private lazy var collectionView: QuickItemFilterView = {
        let collectionView = QuickItemFilterView(frame: .zero)
        collectionView.delegate = presenter
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var displayedItems: [SearchedMovieViewItem] = []
    private var filterItems = [QuickItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
        presenter.viewLoaded()
    }
    
    private func configureView() {
        view.addSubview(moviesTableView)
        view.addSubview(collectionView)
            
        view.backgroundColor = .mainBackground
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .mainBackground
            navigationController?.navigationBar.standardAppearance = appearance;
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.heightAnchor.constraint(equalToConstant: 40),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            moviesTableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5),
            moviesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moviesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.items = filterItems
    }
    
    private func configureNavigationBar() {
        let searchBar = UISearchBar()
        navigationItem.titleView = searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.updateMovies()
    }
}

extension SearchedMoviesViewController: SearchedMoviesView {
    func showMovies(_ movies: [SearchedMovieViewItem]) {
        displayedItems = movies
        moviesTableView.reloadData()
    }
    
    func showGenres(_ genres: [QuickItem]) {
        collectionView.items = genres
    }
}

extension SearchedMoviesViewController: FilterScreenDelegate {
    func filterChosen(_ filters: FilterFields) {
        presenter.filterButtonPressed()
    }
}

extension SearchedMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        presenter.moviePressed(movie: displayedItems[indexPath.row])
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
        cell.movieDescription.text = movie.overview
        guard let url = movie.imageURL else {
            return UITableViewCell()
        }
        cell.ratingView.setImage(url: url)
        cell.ratingView.rating = movie.rating
        cell.ratingView.layer.cornerRadius = 10
        cell.watchLaterButton.setTitle(movie.buttonTitle, for: .normal)
        cell.watchLaterButton.addAction(UIAction(handler: { [unowned presenter, unowned cell] action in
            presenter?.addToWatchMoviePressed(movieItem: movie, action: { result in
                switch result {
                case .success(let newTitle):
                    cell.watchLaterButton.setTitle(newTitle, for: .normal)
                case .failure(_):
                    // TODO: Add error handler
                    break
                }
                
            })
        }), for: .touchUpInside)
        return cell
    }
}

extension SearchedMoviesViewController {
    private enum Consts {
        static let cellIdentifier = String(describing: SearchedMovieTableViewCell.self)
        static let nibFile = "SearchedMovieTableViewCell"
        static let topSearchViewConstant: CGFloat = 20
    }
}

private let addToWishlistButtonTitle =
NSLocalizedString("add_to_wishlist_action",
                  comment: "Action title for adding to wishlist")
private let addedToWishlistButtonTitle =
NSLocalizedString("add_to_wishlist_action_already_added",
                  comment: "Action title for adding to wishlist in inactive state (already added)")
