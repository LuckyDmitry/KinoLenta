//
//  ItemsPickerView.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 09.12.2021.
//

import UIKit

final class ItemsPickerView: UIView {
    private struct Item {
        var isSelected: Bool
        var title: String
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = MyLayout()
        layout.intersectionMargin = Consts.marginBetweenCells
        layout.delegate = self
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.backgroundColor = .mainBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib(nibName: Consts.nibFile, bundle: nil), forCellWithReuseIdentifier: Consts.cellIdentifier)
        return collectionView
    }()
    
    private var items: [Item] = [.init(isSelected: false, title: "First"),
                                 .init(isSelected: false, title: "Second"),
                                 .init(isSelected: false, title: "Second"),
                                 .init(isSelected: false, title: "Second"),
                                 .init(isSelected: false, title: "Second"),
                                 .init(isSelected: false, title: "Second"),
                                 .init(isSelected: false, title: "Second")]
    
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
        collectionView.frame = frame
    }
}

extension ItemsPickerView: ItemPickerCollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, widthForIndexPath indexPath: IndexPath) -> CGFloat {
        let title = items[indexPath.row].title
        let inset = collectionView.contentInset
        let height = collectionView.bounds.height - (inset.top + inset.bottom)
        let width = title.width(withHeight: height, font: UIFont.boldSystemFont(ofSize: Consts.fontSize)) + Consts.textPadding
        return width
    }
}

extension ItemsPickerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Consts.cellIdentifier, for: indexPath) as? GenreItemCollectionViewCell else { fatalError("Invalid cell type") }
        
        let item = items[indexPath.row]
        cell.genreLabel.text = item.title
        cell.isItemSelected = item.isSelected
        cell.genreLabel.sizeToFit()
        cell.layer.cornerRadius = cell.bounds.height / 2
        return cell
    }
}

extension ItemsPickerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for (index, element) in items.enumerated() {
            if index == indexPath.row {
                items[index].isSelected = !items[index].isSelected
            } else if element.isSelected {
                items[index].isSelected = false
            }
        }
        collectionView.reloadData()
    }
}

extension ItemsPickerView {
    private enum Consts {
        static let cellIdentifier = "PickIdentifier"
        static let nibFile = "GenreItem"
        static let fontSize: CGFloat = 17
        static let textPadding: CGFloat = 20
        static let marginBetweenCells: CGFloat = 10
    }
}
