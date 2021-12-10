//
//  StringExtension.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 10.12.2021.
//

import Foundation
import UIKit

extension String {
    func width(withHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}
