//
//  QuickItemFilterView.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 09.12.2021.
//

import UIKit

final class QuickItemFilterView: UIView {
    private struct QuickItem {
        var isSelected: Bool = false
        var title: String
    }
    
    private enum QuickItemLayoutConfig {
        static let font: UIFont = UIFont.boldSystemFont(ofSize: 17)
        static let textPadding: CGFloat = 20
    }
    
    var selectedItems: [Int] = []
    
    var contentSize: CGSize {
        set {
            collectionView.contentSize = newValue
        }
        get {
            collectionView.contentSize
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = QuickItemFilterCollectionViewLayout()
        layout.intersectionMargin = Consts.marginBetweenCells
        layout.delegate = self
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 10)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib(nibName: Consts.nibFile, bundle: nil), forCellWithReuseIdentifier: Consts.cellIdentifier)
        return collectionView
    }()
    
    // TODO: Will be removed
    private var items: [QuickItem] = [QuickItem(title: "Посмотреть"),
                                      QuickItem(title: "Посмотренно")]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
}

extension QuickItemFilterView: QuickItemFilterCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, widthForIndexPath indexPath: IndexPath) -> CGFloat {
        let title = items[indexPath.row].title
        let inset = collectionView.contentInset
        let height = collectionView.bounds.height - (inset.top + inset.bottom)
        let titleWidth = title.width(withHeight: height, font: QuickItemLayoutConfig.font)
        let width = QuickItemLayoutConfig.textPadding + titleWidth
        return width
    }
}

extension QuickItemFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Consts.cellIdentifier, for: indexPath)
        guard let cell = cell as? QuickItemFilterCollectionViewCell else { fatalError("Invalid cell type") }
        
        let item = items[indexPath.row]
        cell.genreLabel.text = item.title
        cell.isItemSelected = item.isSelected
        cell.genreLabel.sizeToFit()
        cell.layer.cornerRadius = ceil(cell.bounds.height / 2)
        return cell
    }
}

extension QuickItemFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        items = items.enumerated().map {
            QuickItem(isSelected: $0 == indexPath.row ? !$1.isSelected : false, title: $1.title)
        }
        collectionView.reloadData()
    }
}

extension QuickItemFilterView {
    private enum Consts {
        static let cellIdentifier = String(describing: QuickItemFilterCollectionViewCell.self)
        static let nibFile = "GenreQuickFilterCell"
        static let fontSize: CGFloat = 17
        static let textPadding: CGFloat = 20
        static let marginBetweenCells: CGFloat = 10
    }
}

extension String {
    func width(withHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}
