//
//  QuickItemFilterCollectionViewCell.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 09.12.2021.
//

import UIKit

final class QuickItemFilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet var genreLabel: UILabel!
    var isItemSelected: Bool = false {
        didSet {
            contentView.backgroundColor = isItemSelected ? .pickerItemBackground : .white
            genreLabel.textColor = isItemSelected ? .white : .buttonActiveBackground
        }
    }
}
