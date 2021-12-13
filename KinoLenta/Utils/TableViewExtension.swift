import Foundation
import UIKit

public struct TableViewCellDescription {
    let cellType: BaseTableViewCell.Type
    public let height: CGFloat
    public var object: Any?
    
    public init(cellType: BaseTableViewCell.Type, height: CGFloat = UITableView.automaticDimension, object: Any?) {
        self.cellType = cellType
        self.height = height
        self.object = object
    }
}

extension UITableView {
    
    public func register<T: BaseTableViewCell>(_ classType: T.Type) {
        register(UINib(nibName: classType.cellIdentifier(), bundle: nil),
                 forCellReuseIdentifier: classType.cellIdentifier())
    }
}

public protocol BaseTableViewCell {
    
    static func cellIdentifier() -> String
}

extension BaseTableViewCell where Self: UITableViewCell {
    
    public static func cellIdentifier() -> String {
        return String(describing: self)
    }
}
