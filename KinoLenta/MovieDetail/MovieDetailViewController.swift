//
//  MovieDetailViewController.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 11.12.2021.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    private enum MovieCellType {
        case title
        case poster
        case details
        case description
        case actions
        case actors
        case reviewTitle
        case review
    }
    
    private var sections: [MovieCellType] = [.poster,
                                             .title,
                                             .details,
                                             .actions,
                                             .description,
                                             .actors,
                                             .reviewTitle,
                                             .review]
    
    private var descriptors: [MovieCellType: [CollectionViewCellDescriptor]] = [:]
    var selectedMovie: MovieItem!
    var cache: CacheService!
    var buttonActions: [(optionType: SavedMovieOption, QuickItem)] = []
    
    private lazy var movieDetailCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createCollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = Consts.collectionViewInset
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private func createCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = Consts.flowViewInset
        layout.minimumLineSpacing = Consts.minimumLineSpacing
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(movieDetailCollectionView)
        view.backgroundColor = .mainBackground
        populateElements()
        movieDetailCollectionView.register(uniqueCells: [
            DetailMovieTextCollectionViewCell.self,
            DetailMovieImageCollectionViewCell.self,
            DetailMovieStarsCollectionViewCell.self,
            DetailMovieReviewCollectionViewCell.self,
            DetailMovieButtonActionsCollectionViewCell.self,
            DetailMovieTrailerCollectionViewCell.self
        ])
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        movieDetailCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        movieDetailCollectionView.frame = view.bounds
    }
    
    // TODO: Will be removed
    private func populateElements() {
        let inset = view.frame.width / 4
        
        let systemFontSize = UIFont.systemFontSize
        
        for section in sections {
            if descriptors[section] == nil {
                descriptors[section] = []
            }
            switch section {
            case .title:
                descriptors[section]?.append(MovieTextItemDescriptor(title: "Ла-Ла Ленд",
                                                                     font: UIFont.boldSystemFont(ofSize: 50),
                                                                     textColor: UIColor.black))
            case .poster:
                descriptors[section]?.append(DetailMovieImageDescriptor(image: UIImage(named: "4"),
                                                                        inset: UIEdgeInsets(top: 20, left: inset, bottom: 20, right: inset)))
            case .details:
                descriptors[section]?.append(MovieTextItemDescriptor(title: "2016, мюзикл, мелодрама США, Гонконг, 2 ч. 8 мин., 16+",
                                                                     font: UIFont.systemFont(ofSize: 18),
                                                                     textColor: UIColor.black.withAlphaComponent(0.5)
                                                                    ))
            case .description:
                descriptors[section]?.append(MovieTextItemDescriptor(title: "Миа и Себастьян выбирают между личным счастьем и амбициями. Трагикомичный мюзикл о компромиссе в жизни артиста",
                                                                     font: UIFont.boldSystemFont(ofSize: systemFontSize),
                                                                     textColor: UIColor.black.withAlphaComponent(0.7),
                                                                     alignment: .left
                                                                    ))
            case .actors:
                descriptors[section]?.append(contentsOf: [DetailMovieStarsDescriptor(primaryFont: UIFont.systemFont(ofSize: systemFontSize),
                                                                                     primaryTitle: "В ролях:",
                                                                                     secondaryFont: UIFont.systemFont(ofSize: systemFontSize),
                                                                                     secondaryTitle: "Дэмьен Шазелл"),
                                                          DetailMovieStarsDescriptor(primaryFont: UIFont.systemFont(ofSize: systemFontSize),
                                                                                     primaryTitle: "Актеры:",
                                                                                     secondaryFont: UIFont.systemFont(ofSize: systemFontSize),
                                                                                     secondaryTitle: "Райан Гослинг, Эмма Стоун, Джон Ледженд, Дж.К. Симмонс, Розмари ДеУитт, Финн Уиттрок, Калли Эрнандес, Соноя Мидзуно, Джессика Рот, Том Эверетт Скотт")])
            case .reviewTitle:
                descriptors[section]?.append(MovieTextItemDescriptor(title: "Отзывы",
                                                                     font: UIFont.boldSystemFont(ofSize: 26),
                                                                     alignment: .left))
            case .review:
                for reviewIndex in 0...1 {
                    var review = DetailMovieReviewDescriptor(image: UIImage(named: "4"),
                                                             nickname: "Волк ну погоди",
                                                             nicknameFont: UIFont.systemFont(ofSize: systemFontSize),
                                                             reviewText: "Сотворив из рядовой подготовки к джазовому концерту неподдельный триллер с зашкаливающим эмоциональным бурлеском, режиссер и сценарист Дэмьен Шазелл сам того не подозревая превратился в одного из на 'Ла-Ла Ленд'. Питая теплые чувство к музыкеСотворив из рядовой подготовки к джазовому концерту неподдельный триллер с зашкаливающим",
                                                             reviewFont: UIFont.systemFont(ofSize: 14),
                                                             heightThreshold: Consts.minHeightTextThreashold)
                    review.openMoreHandler = { [weak self, reviewIndex, review] in
                        let initialOffset = self?.movieDetailCollectionView.contentOffset ?? .zero
                        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                            var updatedReview = review
                            updatedReview.openMoreHandler = nil
                            updatedReview.heightThreshold = Consts.maxHeightTextThreashold
                            guard let section = self?.sections.firstIndex(of: .review) else { return }
                            let indexPath = IndexPath(row: reviewIndex, section: section)
                            self?.descriptors[.review]![reviewIndex] = updatedReview
                            self?.movieDetailCollectionView.reloadItems(at: [indexPath])
                            
                        }, completion: { _ in
                            self?.movieDetailCollectionView.setContentOffset(initialOffset, animated: false)
                        })
                        
                    }
                    descriptors[section]?.append(review)
                }
                
            case .actions:
                let items = buttonActions.map { $1 }
                descriptors[section]?.append(DetailMovieButtonActionsDescriptor(items: items,
                                                                                componentDelegate: self))
            }
        }
    }
}

            }
        }
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let descriptor = descriptors[sections[indexPath.section]] else { fatalError("Invalid section") }
        return descriptor[indexPath.row].sizeForItem(in: collectionView)
    }
}

extension MovieDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return descriptors[sections[section]]?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let descriptor = descriptors[sections[indexPath.section]] else { fatalError("Invalid section") }
        return descriptor[indexPath.row].cell(in: collectionView, at: indexPath)
    }
}

extension MovieDetailViewController: UICollectionViewDelegate {}

extension MovieDetailViewController {
    private enum Consts {
        static let minHeightTextThreashold: CGFloat = 150
        static let maxHeightTextThreashold: CGFloat = 5000
        static let collectionViewInset = UIEdgeInsets(top: 0, left: 20, bottom: 50, right: 20)
        static let flowViewInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        static let minimumLineSpacing: CGFloat = 15
    }
}


