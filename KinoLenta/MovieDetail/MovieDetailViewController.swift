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
    var selectedMovie: MovieDomainModel!
    var service: NetworkingService!
    var cache: CacheService!
    var idMovie: Int!
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
    
    private lazy var starsRatingView: StarsRatingDialogView = {
        let starsRatingView = StarsRatingDialogView(frame: .zero)
        starsRatingView.delegate = self
        starsRatingView.translatesAutoresizingMaskIntoConstraints = false
        return starsRatingView
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
        if let idMovie = idMovie {
            
            for buttonAction in buttonActions {
                cache.getSavedMovies(option: buttonAction.optionType, completion: { result in
                    if case .success(let movies) = result {
                        if movies.contains(where: { $0.id == idMovie }) {
                            let index = self.buttonActions.firstIndex(where: {
                                $0.optionType == buttonAction.optionType
                            }) ?? 0
                            self.buttonActions[index].1.isSelected = true
                            let section = self.sections.firstIndex(of: .actors) ?? 0
                            DispatchQueue.main.async {
                                self.movieDetailCollectionView.reloadSections(IndexSet(integer: section))
                            }
                        }
                    }
                })
            }
            
            service.getById(idMovie, callback: { movie in
                self.selectedMovie = movie
                self.populateElements()
            })
        }
        
        movieDetailCollectionView.register(uniqueCells: [
            DetailMovieTextCollectionViewCell.self,
            DetailMovieImageCollectionViewCell.self,
            DetailMovieStarsCollectionViewCell.self,
            DetailMovieReviewCollectionViewCell.self,
            DetailMovieButtonActionsCollectionViewCell.self
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
                let textDescriptor = MovieTextItemDescriptor(title: selectedMovie.title,
                                                             font: UIFont.boldSystemFont(ofSize: 50),
                                                             textColor: UIColor.darkTextForeground)
                descriptors[section]?.append(textDescriptor)
            case .poster:
                let imageDescriptor = DetailMovieImageDescriptor(imageUrl: selectedMovie.backdropURL,
                                                                 inset: UIEdgeInsets(top: 20, left: inset, bottom: 20, right: inset))
                descriptors[section]?.append(imageDescriptor)
            case .details:
                let textDescriptor = MovieTextItemDescriptor(title: selectedMovie.overview ?? "",
                                                             font: UIFont.systemFont(ofSize: 18),
                                                             textColor: UIColor.darkTextForeground.withAlphaComponent(0.5),
                                                             alignment: .left)
                descriptors[section]?.append(textDescriptor)
            case .description:
                break
            case .actions:
                let items = buttonActions.map { $1 }
                descriptors[section]?.append(DetailMovieButtonActionsDescriptor(items: items,
                                                                                componentDelegate: self))
            case .actors:
                let first = DetailMovieStarsDescriptor(primaryFont: UIFont.systemFont(ofSize: 18),
                                                      primaryTitle: "Режиссер: ",
                                                      secondaryFont: UIFont.systemFont(ofSize: 18),
                                                      secondaryTitle: "Дэмьен Шазелл")
                let second = DetailMovieStarsDescriptor(primaryFont: UIFont.systemFont(ofSize: 18),
                                                      primaryTitle: "В ролях: ",
                                                      secondaryFont: UIFont.systemFont(ofSize: 18),
                                                      secondaryTitle: "Райан Гослинг, Эмма Стоун, Джон Ледженд, Дж.К. Симмонс, Розмари ДеУитт, Финн Уиттрок, Калли Эрнандес, Соноя Мидзуно, Джессика Рот, Том Эверетт Скотт")
                descriptors[section]?.append(first)
                descriptors[section]?.append(second)
            case .reviewTitle:
                let review = MovieTextItemDescriptor(title: "Отзывы", font: UIFont.boldSystemFont(ofSize: 25), alignment: .left)
                descriptors[section]?.append(review)
            case .review:
                for i in 0...3 {
                    let review = DetailMovieReviewDescriptor(nickname: "Волк",
                                                             nicknameFont: UIFont.systemFont(ofSize: 25),
                                                             reviewText: "Сотворив из рядовой подготовки к джазовому концерту неподдельный триллер с зашкаливающим эмоциональным бурлеском, режиссер и сценарист Дэмьен Шазелл сам того не подозревая превратился в одного из наиболее уважаемых и востребованных творцов современности. Проросшая из скромной короткометражки идея была замечена продюсерами и перевоплотилась в полный метр, известный под названием 'Одержимость'. Заставив Дж. К. Симмонса и Майлза Тернера играть в действительности на грани, пройти огонь, воду, медные трубы и в довершении ко всему едва не поубивать друг друга на съемочной площадке, Дэмьен Шазелл собрал внушительный букет положительных откликов от широчайшей аудитории, обеспечивший его детищу блестящие как для малобюджетного кино кассовые сборы, а также стойкие позиции на церемонии награждения премией 'Оскар'. Открыв двери в заветный мир сверкающих софитов Голливуда, Дэмьен Шазелл был вправе выбирать любой приглянувшийся проект, однако вместо переноса чужой идеи на экран он вновь засел за написание сценария, известного нынче как 'Ла-Ла Ленд'. Питая теплые чувство к музыке",
                                                             reviewFont: UIFont.systemFont(ofSize: 17),
                                                             heightThreshold: 250,
                                                             openMoreHandler: { [weak self] in
                        guard let self = self else { return }
                        guard var initSection = self.descriptors[section]?[i] as? DetailMovieReviewDescriptor else { return }
                        initSection.heightThreshold = 5000
                        self.descriptors[section]?[i] = initSection
                        let section = self.sections.firstIndex(of: .review) ?? 0
                        
                        self.movieDetailCollectionView.reloadSections(IndexSet(integer: section))
                    })
                    descriptors[section]?.append(review)
                }
            }
        }
        movieDetailCollectionView.reloadData()
    }
    
    private func showRatingView() {
        view.addSubview(starsRatingView)
        NSLayoutConstraint.activate([
            starsRatingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Consts.edgeMargin),
            starsRatingView.topAnchor.constraint(equalTo: view.topAnchor,
                                            constant: view.frame.midY),
            starsRatingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Consts.edgeMargin)
        ])
        movieDetailCollectionView.isScrollEnabled = false
        movieDetailCollectionView.isUserInteractionEnabled = false
    }
}

extension MovieDetailViewController: StarsRatingDialogDelegate {
    func starsSelected(amount: Int) {
        // TODO: Rating logic
        removeStarsRatingView()
    }
    
    func closedPressed() {
        removeStarsRatingView()
    }
    
    private func removeStarsRatingView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.starsRatingView.removeFromSuperview()
            self?.movieDetailCollectionView.isScrollEnabled = true
            self?.movieDetailCollectionView.isUserInteractionEnabled = true
        })
    }
}

extension MovieDetailViewController: QuickItemFilterDelegate {
    func itemPressed(transition: Transition, isSelected: Bool) {
        switch transition {
        case .singlePress(let index):
            singlePressAction(at: index, isSelected: isSelected)
        case .transitionPress(let indexBefore, let indexAfter):
            transitionPressAction(first: indexBefore, second: indexAfter, isSelected: isSelected)
        }
    }
    
    private func transitionPressAction(first: Int, second: Int, isSelected: Bool) {
        let destType = buttonActions[second].optionType
        let initType = buttonActions[first].optionType
        
        if case  .viewed = destType {
           showRatingView()
        }
        
        cache.changeDirectoryMovies([selectedMovie], from: initType, to: destType, completion: { error in
            // TODO: Handle error
        })
    }
    
    private func singlePressAction(at index: Int, isSelected: Bool) {
        let optionType = buttonActions[index].optionType
        guard !isSelected else {
            if case .viewed = optionType {
                showRatingView()
            }
            cache.saveMovies([selectedMovie], folderType: buttonActions[index].optionType) { error in
                // TODO: Handle error
            }
            return
        }
        
        let alertViewController = UIAlertController(title: "Удалить фильм из \(optionType.description)?",
                                                    message: nil,
                                                    preferredStyle: .alert)
        
        let removeMovieAction = UIAlertAction(title: "Удалить",
                                              style: .destructive,
                                              handler: { [weak self] _ in
            guard let self = self else { return }
            self.cache.removeMovies([self.selectedMovie], directoryType: self.buttonActions[index].optionType) { error in
                // TODO: Handle error
            }
        })
        
        let leaveMovieAction = UIAlertAction(title: "Оставить",
                                   style: .default,
                                   handler: { [weak self] _ in
            guard let self = self else { return }
            alertViewController.dismiss(animated: true)
            let sectionIndex = self.sections.firstIndex(where: { $0 == .actions })
            let buttons = self.buttonActions.enumerated().map {
                QuickItem(isSelected: $0.offset == index, title: $0.element.1.title)
            }
            
            self.descriptors[.actions] = [DetailMovieButtonActionsDescriptor(items: buttons, componentDelegate: self)]
            if let sectionIndex = sectionIndex {
                self.movieDetailCollectionView.reloadSections(IndexSet(integer: sectionIndex))
            }
        })
        
        alertViewController.addAction(removeMovieAction)
        alertViewController.addAction(leaveMovieAction)
        present(alertViewController, animated: true)
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
        static let edgeMargin: CGFloat = 10
    }
}
