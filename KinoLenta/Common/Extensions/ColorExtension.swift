import UIKit

extension UIColor {
    static let mainBackground = UIColor(named: "mainBackground") ?? .clear

    static let pickerItemBackground = UIColor(named: "selectedItemBackground") ?? .clear
    static let pickerUnselectedBackground = UIColor(named: "pickerUnselectedBackground") ?? .clear
    static let pickerTextForeground = UIColor(named: "mainTextForeground") ?? .black
    static let pickerUnselectedTextForeground = UIColor(named: "unselectedTextForeground") ?? .black

    static let buttonTextColor = UIColor(named: "buttonTextColor") ?? .black
    static let buttonActiveBackground = UIColor(named: "buttonActiveBackground") ?? .clear

    static let darkTextForeground = UIColor(named: "darkTextForeground") ?? .black
    static let textPlaceholderForeground = UIColor(named: "textPlaceholderForeground") ?? .gray
    static let darkOrangeTextForeground = UIColor(named: "darkOrangeTextForeground") ?? .orange

    static let greenRating = UIColor(named: "greenRating") ?? .green
    static let yellowRating = UIColor(named: "yellowRating") ?? .yellow
    static let redRating = UIColor(named: "redRating") ?? .red
}
