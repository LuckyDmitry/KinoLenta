//
//  FilmsViewController.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 09.12.2021.
//

import UIKit

struct MovieViewSet {
    let image: UIImage?
    let title: String
    let genre: String
    let description: String
}

final class FilmsViewController: UIViewController {
    @IBOutlet private var placeHolderView: UIView!
    @IBOutlet private var moviesTableView: UITableView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    private var collectionView: ItemsPickerView!
    
    var movies: [MovieViewSet] = []
    var isMoviesLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.backgroundColor = .mainBackground
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        movies = populateMovies()
        moviesTableView.register(UINib(nibName: Consts.nibFile, bundle: nil), forCellReuseIdentifier: Consts.cellIdentifier)
        collectionView = ItemsPickerView(frame: placeHolderView.bounds)
        placeHolderView.addSubview(collectionView)
        navigationItem.title = "Title"
    }
    
    private func populateMovies() -> [MovieViewSet] {
        var movies: [MovieViewSet] = []
        for i in 1...10 {
            let movie = MovieViewSet(image: UIImage(named: "\(i % 5)"),
                                     title: "Путешествие вокруг света",
                                     genre: "Приключения, ужасы",
                                     description: "Эксцентричный лондонский изобретатель Филеас Фогг раскрыл тайны полетов, электричества и многие другие, но общество не принимает его, считая сумасшедшим. Фоггу  ...")
            movies.append(movie)
        }
        return movies
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height && !isMoviesLoading {
            isMoviesLoading = true
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2), execute: { [weak self] in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    self?.movies.append(contentsOf: self?.populateMovies() ?? [])
                    self?.isMoviesLoading = false
                    self?.moviesTableView?.reloadData()
                }
                
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = CGRect(x: collectionView.frame.minX,
                                      y: collectionView.frame.minY,
                                      width: view.frame.width,
                                      height: collectionView.frame.height)
        if collectionView.contentSize.width < view.frame.width {
            collectionView.contentSize = .init(width: view.frame.width + 1,
                                               height: collectionView.contentSize.height)
        }
    }
}

extension FilmsViewController: UITableViewDelegate {
    
}

extension FilmsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Consts.cellIdentifier, for: indexPath) as? MovieTableViewCell else { fatalError("Invalid cell type") }
        let movie = movies[indexPath.row]
        cell.backgroundColor = .mainBackground
        cell.movieTitle.text = movie.title
        cell.movieGenre.text = movie.genre
        cell.movieDescription.text = movie.description
        cell.posterImageView.image = movie.image
        cell.ratingView.rating = 5
        return cell
    }
}

extension FilmsViewController {
    private enum Consts {
        static let cellIdentifier = "MovieTableViewCell"
        static let nibFile = "MovieTableViewCell"
    }
}

