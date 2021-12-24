//
//  StartRatingView.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 16.12.2021.
//

import UIKit

protocol StarsRatingDialogDelegate: AnyObject {
    func starsSelected(amount: Int)
    func closedPressed()
}

final class StarsRatingDialogView: UIView {
    weak var delegate: StarsRatingDialogDelegate?
    var stars: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(closeButton)
        addSubview(starsCollectionView)
        addSubview(pickerView)
        addSubview(titleLabel)
        if let layout = pickerView.collectionView.collectionViewLayout as? QuickItemFilterCollectionViewLayout {
            layout.alignment = .center
        }

        backgroundColor = UIColor.mainBackground
        layer.cornerRadius = Consts.shadowOffsetByY
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = Consts.shadowOffsetByY
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: Consts.shadowOffsetByY)

        pickerView.items = [
            QuickItem(
                title: NSLocalizedString("send_rating_action", comment: "Action title for sending movie rating"),
                minWidth: QuickItemFilterView.Consts.defaultWidth
            ),
        ]

        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Consts.edgeMargin),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: Consts.edgeMargin),
            closeButton.widthAnchor.constraint(equalToConstant: Consts.closeButtonHeight),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),

            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: Consts.edgeMargin),

            starsCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Consts.edgeMargin),
            starsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Consts.edgeMargin),
            starsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Consts.edgeMargin),
            starsCollectionView.heightAnchor.constraint(equalToConstant: 75),

            pickerView.topAnchor.constraint(equalTo: starsCollectionView.bottomAnchor, constant: Consts.edgeMargin),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Consts.edgeMargin),
            pickerView.heightAnchor.constraint(equalToConstant: 40),
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Consts.edgeMargin),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Consts.edgeMargin),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.close?.withTintColor(.white), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: Consts.buttonImageInset,
                                              left: Consts.buttonImageInset,
                                              bottom: Consts.buttonImageInset,
                                              right: Consts.buttonImageInset)
        button.layer.cornerRadius = floor(Consts.closeButtonHeight / 2)
        button.backgroundColor = .pickerItemBackground.withAlphaComponent(0.7)
        button.contentHorizontalAlignment = .fill
        button.addAction(UIAction { [weak self]_ in
            self?.delegate?.closedPressed()
        }, for: .touchUpInside)
        button.contentVerticalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var pickerView: QuickItemFilterView = {
        let pickerView = QuickItemFilterView(frame: .zero)
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("rating_dialog_title", comment: "Title for rate movie dialog")
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var starsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: floor(bounds.width / CGFloat(Consts.amountOfItems)), height: bounds.height)
        let starsCollectionView = UICollectionView(frame: .zero,
                                         collectionViewLayout: flowLayout)
        starsCollectionView.backgroundColor = .clear
        starsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        starsCollectionView.delegate = self
        starsCollectionView.dataSource = self
        starsCollectionView.allowsSelection = true

        starsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "id")

        return starsCollectionView
    }()
}

extension StarsRatingDialogView: QuickItemFilterDelegate {
    func itemPressed(transition: Transition, isSelected: Bool) {
        if case .singlePress(let index) = transition {
            delegate?.starsSelected(amount: index)
        }
    }
}

extension StarsRatingDialogView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        stars = indexPath.row
        starsCollectionView.reloadData()
    }
}

extension StarsRatingDialogView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Consts.amountOfItems - 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath)

        cell.subviews.forEach { $0.removeFromSuperview() }
        let imageView = UIImageView(image: indexPath.row <= stars ? .filledStar : .star)
        imageView.frame = cell.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .pickerItemBackground
        imageView.isUserInteractionEnabled = true

        cell.addSubview(imageView)

        return cell
    }
}

extension StarsRatingDialogView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(collectionView.widthWithInsets / CGFloat(Consts.amountOfItems))
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
}

extension StarsRatingDialogView {
    private enum Consts {
        static let amountOfItems: Int = 6
        static let edgeMargin: CGFloat = 5
        static let closeButtonHeight: CGFloat = 30
        static let shadowOffsetByY: CGFloat = 10
        static let buttonImageInset: CGFloat = 5
    }
}

