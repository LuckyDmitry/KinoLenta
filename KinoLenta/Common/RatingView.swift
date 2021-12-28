//
//  RatingImageView.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 09.12.2021.
//

import UIKit

// UI without storyboard
final class RatingView: UIView {
    private lazy var ratingLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.textAlignment = .center
        ratingLabel.textColor = UIColor.white
        ratingLabel.font = UIFont(name: "SFProDisplay-Bold", size: Consts.ratingFontSize) ?? UIFont.boldSystemFont(ofSize: Consts.ratingFontSize)
        return ratingLabel
    }()

    var ratingView: UIView = {
        let ratingView = UIView()
        ratingView.clipsToBounds = true
        return ratingView
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    var image: UIImage? {
        didSet {
            imageView.image = UIImage.moviePlaceholder
            setBorder(isBorderActive: true)
        }
    }

    private var cancellation: CancellationHandle?

    func setImage(url: URL) {
        cancellation = imageView.setImage(url: url, traits: .thumbnail)
        setBorder(isBorderActive: false)
    }

    func reset() {
        cancellation?.cancel()

        image = nil
        ratingLabel.text = nil
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private func configureView() {
        addSubview(imageView)
        addSubview(ratingView)
        ratingView.addSubview(ratingLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        let ratingViewSize = CGSize(width: bounds.width / Consts.divider,
                                    height: bounds.width / Consts.divider)
        let ratingViewOrigin = CGPoint(x: bounds.minX, y: bounds.maxY - ratingViewSize.height)
        ratingView.frame = CGRect(origin: ratingViewOrigin,
                                  size: ratingViewSize)
        ratingLabel.frame = ratingView.bounds
    }

    var rating: Double? {
        didSet {
            guard let rating = rating else {
                return
            }

            let newColor: UIColor
            switch rating {
            case .zero...Consts.maxRedRating:
                newColor = .redRating
            case Consts.maxRedRating...Consts.maxYellowRating:
                newColor = .yellowRating
            case Consts.maxYellowRating...Consts.maxGreenRating:
                newColor = .greenRating
            default:
                newColor = .greenRating
            }
            ratingView.backgroundColor = newColor
            ratingLabel.text = "\(rating)"
        }
    }

    private func setBorder(isBorderActive: Bool) {
        imageView.layer.borderColor = isBorderActive ? UIColor.gray.cgColor : UIColor.clear.cgColor
        imageView.layer.borderWidth = isBorderActive ? 0.2 : 0
    }
}

extension RatingView {
    private enum Consts {
        static let ratingFontSize: CGFloat = 14
        static let divider: CGFloat = 4
        static let maxRedRating: Double = 4
        static let maxYellowRating: Double = 6
        static let maxGreenRating: Double = 10
    }
}
