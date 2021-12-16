//
//  CollectionViewExtension.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 14.12.2021.
//

import Foundation
import UIKit

extension UICollectionView {
    var widthWithInsets: CGFloat {
        let inset = contentInset
        return bounds.width - (inset.left + inset.right)
    }
    
    func register(uniqueCells: [UICollectionViewCell.Type]) {
        for cell in uniqueCells {
            let identifier = String(describing: cell)
            self.register(cell, forCellWithReuseIdentifier: identifier)
        }
    }
}
