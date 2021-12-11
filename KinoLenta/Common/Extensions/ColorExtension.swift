//
//  ColorExtension.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 09.12.2021.
//

import UIKit

extension UIColor {
    static var mainBackground: UIColor {
        UIColor(named: "mainBackground") ?? .clear
    }
    
    static var pickerItemBackground: UIColor {
        UIColor(named: "selectedItemBackground") ?? .clear
    }
    
    static var pickerUnselectedBackground: UIColor {
        UIColor(named: "pickerUnselectedBackground") ?? .clear
    }
    
    static var pickerTextForeground: UIColor {
        UIColor(named: "mainTextForeground") ?? .clear
    }
    
    static var pickerUnselectedTextForeground: UIColor {
        UIColor(named: "unselectedTextForeground") ?? .clear
    }
    
    
    static var greenRating: UIColor {
        UIColor(named: "greenRating") ?? .clear
    }
    
    static var yellowRating: UIColor {
        UIColor(named: "yellowRating") ?? .clear
    }
    
    static var redRating: UIColor {
        UIColor(named: "redRating") ?? .clear
    }
}
