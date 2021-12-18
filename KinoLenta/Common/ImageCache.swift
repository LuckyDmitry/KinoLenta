import Foundation
import UIKit
import CommonCrypto

final class ImageCache {
    
    static let shared = ImageCache()
    
    private let fileManager = FileManager()
    private let queue = DispatchQueue(label: "ImageCacheQueue", attributes: .concurrent)
    private let inMemoryCache = NSCache<NSString, UIImage>()
    private lazy var directory: URL = {
        let arrayPaths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        var cacheDirectoryPath = arrayPaths[0]
        cacheDirectoryPath.appendPathComponent("ImageCache/")
        return cacheDirectoryPath
    }()
    
    init() {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            try? self.fileManager.createDirectory(
                at: self.directory,
                withIntermediateDirectories: false,
                attributes: nil
            )
        }
    }

    // Note: UIImage should be safe to create and use from any thread
    // See https://developer.apple.com/documentation/uikit/uiimage
    
    func load(for url: URL, traits: ImageSizeTraits = .normal, callback: @escaping (UIImage?) -> Void) {
        assert(Thread.isMainThread)
        if let image = readFromInMemoryCache(url: url, traits: traits) {
            callback(image)
            return
        }

        readFromFileCache(url: url, traits: traits) { [weak self] image in
            assert(Thread.isMainThread)
            if let image = image {
                self?.addToInMemoryCache(image, url: url, traits: traits)
                callback(image)
                return
            }

            self?.downloadFromNetwork(imageUrl: url) { [weak self] imageData, image in
                assert(Thread.isMainThread)
                
                self?.addToFileCache(imageData, url: url, traits: .normal)

                guard let image = image else {
                    callback(nil)
                    return
                }

                image.downscaled(maxDimention: 256) { thumbnail, thumbnailData in
                    if let imageData = thumbnailData {
                        self?.addToFileCache(imageData, url: url, traits: .thumbnail)
                    }

                    self?.addToInMemoryCache(thumbnail, url: url, traits: traits)
                    callback(traits == .normal ? image : thumbnail)
                }
            }
        }
    }

    private func readFromInMemoryCache(url: URL, traits: ImageSizeTraits) -> UIImage? {
        inMemoryCache.object(forKey: url.inMemoryCacheKey(traits: traits))
    }

    private func addToInMemoryCache(_ image: UIImage, url: URL, traits: ImageSizeTraits) {
        inMemoryCache.setObject(image, forKey: url.inMemoryCacheKey(traits: traits))
    }

    private func readFromFileCache(url: URL, traits: ImageSizeTraits, callback: @escaping (UIImage?) -> Void) {
        let fileURL = fileCachePath(for: url, traits: traits)
        queue.async { [fileManager] in
            let imageData = fileManager.fileExists(atPath: fileURL.path)
                ? fileManager.contents(atPath: fileURL.path)
                : nil
            let image = imageData?.toImage()
            DispatchQueue.main.async {
                callback(image)
            }
        }
    }

    private func addToFileCache(_ imageData: Data?, url: URL, traits: ImageSizeTraits) {
        guard let imageData = imageData else { return }
        let fileURL = fileCachePath(for: url, traits: traits)
        queue.async(flags: .barrier) {
            try? imageData.write(to: fileURL)
        }
    }

    private func fileCachePath(for url: URL, traits: ImageSizeTraits) -> URL {
        directory.appendingPathComponent(url.imageNameForCaching(traits: traits))
    }
    
    private func downloadFromNetwork(imageUrl: URL, callback: @escaping (Data?, UIImage?) -> Void) {
        DispatchQueue.global().async {
            self.downloadData(from: imageUrl) { data, _, error in
                if let error = error {
                    print(error)
                }
                let image = data?.toImage()
                DispatchQueue.main.async {
                    callback(data, image)
                }
            }
        }
    }
    
    private func downloadData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

extension URL {
    fileprivate func imageNameForCaching(traits: ImageSizeTraits) -> String {
        switch traits {
        case .normal:
            return nameForCaching()
        case .thumbnail:
            return nameForCaching() + "_thumbnail"
        }
    }

    fileprivate func inMemoryCacheKey(traits: ImageSizeTraits) -> NSString {
        NSString(string: imageNameForCaching(traits: traits))
    }
}

extension UIImage {
    func downscaled(maxDimention: CGFloat, callback: @escaping (UIImage, Data?) -> Void) {
        DispatchQueue.global().async {
            let image = self.downscaled(maxDimention: maxDimention)
            let data = image.toData()
            DispatchQueue.main.async {
                callback(image, data)
            }
        }
    }
}
