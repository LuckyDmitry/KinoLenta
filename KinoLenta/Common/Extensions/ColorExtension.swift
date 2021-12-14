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
    
    static var buttonActiveBackground: UIColor {
        UIColor(named: "buttonActiveBackground") ?? .clear
    }
    
    static var pickerTextForeground: UIColor {
        UIColor(named: "mainTextForeground") ?? .clear
    }
    
    static var pickerUnselectedTextForeground: UIColor {
        UIColor(named: "unselectedTextForeground") ?? .clear
    }
    
    static var darkTextForeground: UIColor {
        UIColor(named: "darkTextForeground") ?? .clear
    }
    
    static var textPlaceholderForeground: UIColor {
        UIColor(named: "textPlaceholderForeground") ?? .clear
    }
    
    static var darkOrangeTextForeground: UIColor {
        UIColor(named: "darkOrangeTextForeground") ?? .clear
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
