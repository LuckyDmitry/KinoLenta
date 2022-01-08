import Foundation
import UIKit

extension UIImageView {
    func setImage(url: URL, traits: ImageSizeTraits = .normal) -> CancellationHandle {
        let handle = CancellationHandle()
        ImageCache.shared.load(for: url, traits: traits) { [weak self] image in
            if #available(iOS 15, *) {
                image?.prepareForDisplay { image in
                    DispatchQueue.main.async {
                        if !handle.isCancelled {
                            self?.image = image
                        }
                    }
                }
            } else if !handle.isCancelled {
                self?.image = image
            }
        }
        return handle
    }
}
