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
    
    func load(for url: URL, callback: @escaping (UIImage?) -> Void) {
        let fileURL = directory.appendingPathComponent(url.nameForCaching())
        let imageKey = NSString(string: url.nameForCaching())
        if let image = inMemoryCache.object(forKey: imageKey) {
            callback(image)
            return
        }

        readFromFileCache(from: fileURL) { [weak self] image in
            if let image = image {
                self?.inMemoryCache.setObject(image, forKey: imageKey)
                callback(image)
                return
            }

            self?.downloadFromNetwork(imageUrl: url) { [weak self] imageData in
                if let imageData = imageData {
                    self?.addToFileCache(imageData, fileURL: fileURL)
                }
                let image = imageData?.toImage()
                if let image = image {
                    self?.inMemoryCache.setObject(image, forKey: imageKey)
                }
                
                DispatchQueue.main.async {
                    callback(image)
                }
            }
        }
    }

    private func readFromFileCache(from url: URL, callback: @escaping (UIImage?) -> Void) {
        queue.async { [fileManager] in
            let imageData = fileManager.fileExists(atPath: url.path)
            ? fileManager.contents(atPath: url.path)
            : nil
            DispatchQueue.main.async {
                callback(imageData?.toImage())
            }
        }
    }
    
    private func downloadFromNetwork(imageUrl: URL, callback: @escaping (Data?) -> Void) {
        DispatchQueue.global().async {
            self.downloadData(from: imageUrl) { data, _, error in
                if let error = error {
                    print(error)
                }
                callback(data)
            }
        }
    }
    
    private func addToFileCache(_ imageData: Data, fileURL: URL) {
        queue.async(flags: .barrier) {
            try? imageData.write(to: fileURL)
        }
    }
    
    private func downloadData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
