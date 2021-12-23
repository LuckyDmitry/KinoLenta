import UIKit

extension UIImage {
    func downscaled(maxDimention: CGFloat) -> UIImage {
        guard size.width > maxDimention || size.height > maxDimention else { return self }

        let factor = maxDimention / max(size.width, size.height)
        let scaledSize = CGSize(width: round(size.width * factor), height: round(size.height * factor))

        return UIGraphicsImageRenderer(size: scaledSize).image { _ in
            draw(in: CGRect(origin: .zero, size: scaledSize))
        }
    }

    func toData() -> Data? {
        jpegData(compressionQuality: 1)
    }
}
