//
//  QuickItemPickerCollectionViewLayout.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 09.12.2021.
//

import Foundation
import UIKit

protocol QuickItemFilterCollectionViewLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        widthForIndexPath indexPath: IndexPath
    ) -> CGFloat
}

protocol QuickItemFilterLayoutLifeCycleDelegate: AnyObject {
    func prepareLayoutDidFinish(contentSize: CGSize)
}

final class QuickItemFilterCollectionViewLayout: UICollectionViewLayout {
    enum Alignment {
        case left
        case center
    }

    weak var delegate: QuickItemFilterCollectionViewLayoutDelegate?
    weak var lifeCycleDelegate: QuickItemFilterLayoutLifeCycleDelegate?
    var intersectionMargin: CGFloat = 0
    var alignment = Alignment.left

    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentWidth: CGFloat = 0
    private var contentHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }

        let inset = collectionView.contentInset
        let height = collectionView.bounds.height - (inset.bottom + inset.top)
        return height
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard cache.isEmpty,
              let collectionView = collectionView else { return }

        let topInset = collectionView.contentInset.top
        let bottomInset = collectionView.contentInset.bottom
        let leadingInset = collectionView.contentInset.left
        let trailingInset = collectionView.contentInset.right

        contentWidth = leadingInset + intersectionMargin

        assert(collectionView.numberOfSections == 1)

        let section = 0

        let amountOfItems = collectionView.numberOfItems(inSection: section)
        var frames = [CGRect]()

        for index in 0..<amountOfItems {
            let height = contentHeight - (bottomInset + topInset)
            let width = delegate?.collectionView(
                collectionView,
                widthForIndexPath: IndexPath(row: index, section: section)
            ) ?? QuickItemFilterView.Consts.defaultWidth
            let frame = CGRect(x: contentWidth, y: topInset, width: width, height: height)
            frames.append(frame)
            contentWidth = max(contentWidth, frame.maxX) + intersectionMargin
        }

        contentWidth += trailingInset

        var offset: CGFloat = 0
        if case .center = alignment {
            offset = max(floor((collectionView.bounds.width - contentWidth) / 2), 0)
            contentWidth += offset
        }
        for index in 0..<amountOfItems {
            let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: index, section: section))
            layoutAttribute.frame = frames[index].offsetBy(dx: offset, dy: 0)
            cache.append(layoutAttribute)
        }

        lifeCycleDelegate?.prepareLayoutDidFinish(contentSize: collectionViewContentSize)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        contentWidth = 0
        cache.removeAll()
        return true
    }
}
