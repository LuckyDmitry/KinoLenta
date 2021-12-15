import Foundation
import UIKit

extension UIImageView {    
    func setImage(url: URL) {
        ImageCache.shared.load(for: url) { image in
            self.image = image
       }
    }
}
