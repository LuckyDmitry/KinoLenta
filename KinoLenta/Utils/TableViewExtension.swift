import Foundation
import UIKit

public struct TableViewCellDescription {
    let cellType: BaseTableViewCell.Type
    public let height: CGFloat
    public var object: Any?
    
    public init(
        cellType: BaseTableViewCell.Type,
        height: CGFloat = UITableView.automaticDimension
    ) {
        self.cellType = cellType
        self.height = height
    }
}

extension UITableView {
    
    public func register<T: BaseTableViewCell>(_ classType: T.Type) {
        register(UINib(nibName: classType.cellIdentifier, bundle: nil),
                 forCellReuseIdentifier: classType.cellIdentifier)
    }
}

public protocol BaseTableViewCell {
    
    static var cellIdentifier: String { get }
}

extension BaseTableViewCell where Self: UITableViewCell {
    
    
    public static var cellIdentifier: String {
        String(describing: self)
    }
}
