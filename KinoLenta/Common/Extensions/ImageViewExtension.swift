import Foundation
import UIKit

extension UIImageView {    
    func setImage(url: URL, traits: ImageSizeTraits = .normal) -> CancellationHandle {
        let handle = CancellationHandle()
        ImageCache.shared.load(for: url, traits: traits) { image in
            if !handle.isCancelled {
                self.image = image
            }
       }
       return handle
    }
}
