import UIKit

extension UIImage {
    func downscaled(maxDimension: CGFloat) -> UIImage {
        guard size.width > maxDimension || size.height > maxDimension else { return self }

        let factor = maxDimension / max(size.width, size.height)
        let scaledSize = CGSize(width: round(size.width * factor), height: round(size.height * factor))

        return UIGraphicsImageRenderer(size: scaledSize).image { _ in
            draw(in: CGRect(origin: .zero, size: scaledSize))
        }
    }

    func toData() -> Data? {
        jpegData(compressionQuality: 1)
    }
}
