//
//  MovieDetailViewController.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 11.12.2021.
//

import UIKit

class MovieDetailViewController: UIViewController {
    private enum MovieCellType {
        case title
        case details
        case description
        case trailer
        case actors
        case reviewTitle
        case review
    }
    
    private var sections: [MovieCellType] = [.title, .details, .description]
    private var descriptors: [[CollectionViewCellDescriptor]] = []
    private lazy var movieDetailCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createCollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private func createCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 10, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 15
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(movieDetailCollectionView)
        populateElements()
        movieDetailCollectionView.register(MovieTextItemCollectionViewCell.self,
                                           forCellWithReuseIdentifier: String(describing: MovieTextItemCollectionViewCell.self))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        movieDetailCollectionView.frame = view.bounds
    }
    
    private func populateElements() {
        for cellIndex in 0..<sections.count {
            descriptors.append([MovieTextItemDescriptor(font: UIFont.systemFont(ofSize: 17),
                                                          title: "MyTitle")])

        }
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return descriptors[indexPath.section][indexPath.row].sizeForItem(in: collectionView)
    }
}

extension MovieDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return descriptors[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return descriptors[indexPath.section][indexPath.row].cell(in: collectionView, at: indexPath)
    }
}

extension MovieDetailViewController: UICollectionViewDelegate {

}
