import Foundation
import UIKit

extension Data {
    func toImage() -> UIImage? {
        UIImage(data: self)
    }
}
