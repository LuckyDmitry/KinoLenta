//
//  MovieDetailViewController.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 11.12.2021.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    enum MovieCellType {
        case title
        case poster
        case details
        case actions
        case starring
        case reviewTitle
        case review
    }

    private let sections: [MovieCellType] = [
        .poster,
        .title,
        .details,
        .actions,
        .starring,
        .reviewTitle,
        .review
    ]

    private var descriptors: [MovieCellType: [CollectionViewCellDescriptor]] = [:]
    private let cache: CacheService
    private var viewModel: MovieDetailViewModel
    // TODO(stonespb): Remove and use movie id for operations
    private var selectedMovie: MovieDomainModel!

    private lazy var movieDetailCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCollectionViewFlowLayout()
        )
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

    init(
        viewModel: MovieDetailViewModel,
        cache: CacheService,
        networkService: NetworkingService
    ) {
        self.viewModel = viewModel
        self.cache = cache
        super.init(nibName: nil, bundle: nil)

        _ = networkService.getById(viewModel.movieId) { [weak self] movie in
            self?.selectedMovie = movie
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCellFor(section: MovieCellType) -> UICollectionViewCell? {
        guard let sectionIndex = sections.firstIndex(where: { $0 == section}) else { return nil }
        let cell = movieDetailCollectionView.cellForItem(at: IndexPath(row: 0, section: sectionIndex))
        return cell
    }

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
        for buttonAction in viewModel.buttonActions {
            cache.getSavedMovies(option: buttonAction.option) { [weak self] result in
                assert(Thread.isMainThread)
                guard let self = self else { return }
                if case .success(let movies) = result {
                    guard movies.contains(where: { $0.id == self.viewModel.movieId }),
                          let index = self.viewModel.buttonActions.firstIndex(where: {
                              $0.option == buttonAction.option
                          })
                    else { return }

                    self.viewModel.buttonActions[index].item.isSelected = true
                    self.reloadActions()
                }
            }
        }

        movieDetailCollectionView.register(uniqueCells: [
            DetailMovieTextCollectionViewCell.self,
            DetailMovieImageCollectionViewCell.self,
            DetailMovieStarsCollectionViewCell.self,
            DetailMovieReviewCollectionViewCell.self,
            DetailMovieButtonActionsCollectionViewCell.self
        ])

        populateElements()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        movieDetailCollectionView.collectionViewLayout.invalidateLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        movieDetailCollectionView.frame = view.bounds
    }

    private func makeActionsDescriptor() -> DetailMovieButtonActionsDescriptor {
        DetailMovieButtonActionsDescriptor(
            items: viewModel.buttonActions.map { $0.item },
            componentDelegate: self
        )
    }

    private func reloadActions() {
        descriptors[.actions] = [makeActionsDescriptor()]
        if let section = sections.firstIndex(of: .actions) {
            movieDetailCollectionView.reloadSections(IndexSet(integer: section))
        }
    }

    // TODO: Will be removed
    private func populateElements() {
        for section in sections {
            func addDecriptor(_ descriptor: CollectionViewCellDescriptor) {
                descriptors[section, default: []].append(descriptor)
            }

            switch section {
            case .title:
                let textDescriptor = MovieTextItemDescriptor(
                    title: viewModel.title,
                    font: UIFont.boldSystemFont(ofSize: 50),
                    textColor: UIColor.darkTextForeground
                )
                addDecriptor(textDescriptor)
            case .poster:
                if let imageURL = viewModel.imageURL {
                    let inset = floor(view.frame.width / 4)
                    let imageDescriptor = DetailMovieImageDescriptor(
                        imageURL: imageURL,
                        inset: UIEdgeInsets(
                            top: 20,
                            left: inset,
                            bottom: 20,
                            right: inset
                        )
                    )
                    addDecriptor(imageDescriptor)
                }
            case .details:
                if let overview = viewModel.overview {
                    let textDescriptor = MovieTextItemDescriptor(
                        title: overview,
                        font: UIFont.systemFont(ofSize: 18),
                        textColor: UIColor.darkTextForeground.withAlphaComponent(0.5),
                        alignment: .left
                    )
                    addDecriptor(textDescriptor)
                }
            case .actions:
                addDecriptor(makeActionsDescriptor())
            case .starring:
                // TODO(stonespb): Localization
                if let director = viewModel.director {
                    let descriptor = DetailMovieStarsDescriptor(
                        primaryFont: UIFont.systemFont(ofSize: 18),
                        primaryTitle: "Режиссер: ",
                        secondaryFont: UIFont.systemFont(ofSize: 18),
                        secondaryTitle: director
                    )
                    addDecriptor(descriptor)
                }
                if let starring = viewModel.starring {
                    let descriptor = DetailMovieStarsDescriptor(
                        primaryFont: UIFont.systemFont(ofSize: 18),
                        primaryTitle: "В ролях: ",
                        secondaryFont: UIFont.systemFont(ofSize: 18),
                        secondaryTitle: starring
                    )
                    addDecriptor(descriptor)
                }
            case .reviewTitle:
                if !viewModel.reviews.isEmpty {
                    let reviewTitle = MovieTextItemDescriptor(
                        title: NSLocalizedString(
                            "movie_reviews_section_title",
                            comment: "Reviews section title on movie details screen"
                        ),
                        font: UIFont.boldSystemFont(ofSize: 25),
                        alignment: .left
                    )
                    addDecriptor(reviewTitle)
                }
            case .review:
                for (i, review) in viewModel.reviews.enumerated() {
                    let review = DetailMovieReviewDescriptor(
                        nickname: review.nickname,
                        nicknameFont: UIFont.systemFont(ofSize: 25),
                        reviewText: review.text,
                        reviewFont: UIFont.systemFont(ofSize: 17),
                        heightThreshold: 250,
                        openMoreHandler: { [weak self] in
                            guard let self = self,
                                  var descriptor = self.descriptors[section]?[i] as? DetailMovieReviewDescriptor
                            else { return }
                            descriptor.heightThreshold = 5000
                            self.descriptors[section]?[i] = descriptor
                            if let section = self.sections.firstIndex(of: .review) {
                                self.movieDetailCollectionView.reloadSections(IndexSet(integer: section))
                            }
                        }
                    )
                    addDecriptor(review)
                }
            }
        }
        movieDetailCollectionView.reloadData()
    }

    private func showRatingView() {
        view.addSubview(starsRatingView)
        NSLayoutConstraint.activate([
            starsRatingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Consts.edgeMargin),
            starsRatingView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: view.frame.midY
            ),
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
        let destType = viewModel.buttonActions[second].option
        let initType = viewModel.buttonActions[first].option

        if case .watched = destType {
            showRatingView()
        }

        cache.changeDirectoryMovies([selectedMovie], from: initType, to: destType, completion: { error in
            // TODO: Handle error
        })
    }

    private func singlePressAction(at index: Int, isSelected: Bool) {
        let optionType = viewModel.buttonActions[index].option
        guard !isSelected else {
            if case .watched = optionType {
                showRatingView()
            }
            cache.saveMovies([selectedMovie], folderType: optionType) { error in
                // TODO: Handle error
            }
            return
        }

        let alertViewController = UIAlertController(
            title: deleteMessage(for: optionType),
            message: nil,
            preferredStyle: .alert
        )

        let removeMovieAction = UIAlertAction(
            title: NSLocalizedString(
                "remove_from_list_remove_action",
                comment: "Remove action title for dialog on removing movie from list"
            ),
            style: .destructive
        ) { [weak self] _ in
            guard let self = self else { return }
            self.cache.removeMovies(
                [self.selectedMovie],
                directoryType: self.viewModel.buttonActions[index].option
            ) { error in
                // TODO: Handle error
            }
        }

        let leaveMovieAction = UIAlertAction(
            title: NSLocalizedString(
                "remove_from_list_cancel_action",
                comment: "Cancel action title for dialog on removing movie from list"
            ),
            style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            alertViewController.dismiss(animated: true)
            let sectionIndex = self.sections.firstIndex(where: { $0 == .actions })
            let buttons = self.viewModel.buttonActions.enumerated().map {
                QuickItem(isSelected: $0.offset == index, title: $0.element.item.title)
            }

            self.descriptors[.actions] = [DetailMovieButtonActionsDescriptor(items: buttons, componentDelegate: self)]
            if let sectionIndex = sectionIndex {
                self.movieDetailCollectionView.reloadSections(IndexSet(integer: sectionIndex))
            }
        }

        alertViewController.addAction(removeMovieAction)
        alertViewController.addAction(leaveMovieAction)
        present(alertViewController, animated: true)
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
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

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let descriptor = descriptors[sections[indexPath.section]] else { fatalError("Invalid section") }
        return descriptor[indexPath.row].cell(in: collectionView, at: indexPath)
    }
}

extension MovieDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true)
    }
}

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

private func deleteMessage(for option: SavedMovieOption) -> String {
    switch option {
    case .watched:
        return NSLocalizedString(
            "remove_from_watched_list_dialog_message",
            comment: "Message for dialog on removing movie from watched list"
        )
    case .wishToWatch:
        return NSLocalizedString(
            "remove_from_wishlist_dialog_message",
            comment: "Message for dialog on removing movie from wishlist"
        )
    }
}
