import Foundation
import UIKit

extension Data {
    func toImage() -> UIImage? {
        UIImage(data: self)
    }

    var hexDescription: String {
        return reduce("") { $0 + String(format: "%02x", $1) }
    }
}
