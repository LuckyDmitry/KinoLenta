//
//  DetailMovieButtonActionsCollectionViewCell.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 13.12.2021.
//

import UIKit

final class DetailMovieButtonActionsCollectionViewCell: UICollectionViewCell {
    var items: [QuickItem] = [] {
        didSet {
            filterComponent.items = items
        }
    }
    
    let filterComponent = QuickItemFilterView(frame: .zero)
    private let layoutManager = AnyLayoutManager<DetailMovieButtonActionsCollectionViewCell>(DetailMovieButtonActionsLayoutManager())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(filterComponent)
        if let layout = filterComponent.collectionView.collectionViewLayout as? QuickItemFilterCollectionViewLayout {
            layout.lifeCycleDelegate = self
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutManager.applyLayout(for: self, bounds: bounds)
    }
}

extension DetailMovieButtonActionsCollectionViewCell: QuickItemFilterLayoutLifeCycleDelegate {
    func prepareLayoutDidFinish(contentSize: CGSize) {
        let contentWidth = contentSize.width
        
        let availableWidth = bounds.width - contentWidth
        let horizontalInset = availableWidth > 0 ? floor(availableWidth / 2) : .zero
        filterComponent.collectionView.contentInset = .init(top: .zero,
                                                            left: horizontalInset,
                                                            bottom: .zero,
                                                            right: .zero)
    }
}
