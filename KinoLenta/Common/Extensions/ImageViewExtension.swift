import Foundation
import UIKit

extension UIImageView {
    func setImage(imagePath: String) {
        guard let url = URL(string: imagePath) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
