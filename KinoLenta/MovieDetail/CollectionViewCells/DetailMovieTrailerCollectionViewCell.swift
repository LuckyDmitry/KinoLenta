//
//  DetailMovieTrailerCollectionViewCell.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 13.12.2021.
//

import AVFoundation
import AVKit

final class DetailMovieTrailerCollectionViewCell: UICollectionViewCell, AVPlayerViewControllerDelegate {
    let player = AVPlayerViewController()

    private let layoutManager =
        AnyLayoutManager<DetailMovieTrailerCollectionViewCell>(DetailMovieTrailerLayoutManager())

    override init(frame: CGRect) {
        super.init(frame: frame)
        player.delegate = self
        contentView.addSubview(player.view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutManager.applyLayout(for: self, bounds: bounds)
    }
}
