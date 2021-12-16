//
//  QuickItemPickerCollectionViewLayout.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 09.12.2021.
//

import UIKit
import Foundation

protocol QuickItemFilterCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView,
                        widthForIndexPath indexPath: IndexPath) -> CGFloat
}

protocol QuickItemFilterLayoutLifeCycleDelegate: AnyObject {
    func prepareLayoutDidFinish(contentSize: CGSize)
}

final class QuickItemFilterCollectionViewLayout: UICollectionViewLayout {
    weak var delegate: QuickItemFilterCollectionViewLayoutDelegate?
    weak var lifeCycleDelegate: QuickItemFilterLayoutLifeCycleDelegate?
    var intersectionMargin: CGFloat = 0
    
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
        
        contentWidth = leadingInset
        
        assert(collectionView.numberOfSections == 1)
        
        let section = 0
        
        let amountOfItems = collectionView.numberOfItems(inSection: section)
        
        for index in 0..<amountOfItems {
            let indexPath = IndexPath(row: index, section: section)
            let height = contentHeight - (bottomInset + topInset)
            let width = delegate?.collectionView(collectionView,
                                                 widthForIndexPath: indexPath) ?? 100
            let frame = CGRect(x: contentWidth,y: topInset,width: width,height: height)
            contentWidth = max(contentWidth, frame.maxX) + intersectionMargin
            let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            layoutAttribute.frame = frame
            cache.append(layoutAttribute)
        }
        
        contentWidth += trailingInset
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
