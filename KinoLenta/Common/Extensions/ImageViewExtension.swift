import Foundation
import UIKit

extension UIImageView {    
    func setImage(url: URL) -> CancellationHandle {
        let handle = CancellationHandle()
        ImageCache.shared.load(for: url) { image in
            if !handle.isCancelled {
                self.image = image
            }
       }
       return handle
    }
}
