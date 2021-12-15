import Foundation
import UIKit
import CommonCrypto

final class ImageCache {
    
    static let shared = ImageCache()
    
    private let fileManager = FileManager()
    private let queue = DispatchQueue(label: "ImageCacheQueue", attributes: .concurrent)
    private lazy var directory = getImageCacheDirectoryPath()
    
    func load(for url: URL, callback: @escaping (UIImage?) -> Void) {
        let fileURL = directory.appendingPathComponent(url.nameForCaching())
        
        if fileManager.fileExists(atPath: fileURL.path) {
          readFromCache(from: fileURL, callback: callback)
          return
        }
        loadFromNetwork(imageUrl: url) { [weak self] imageData in
            if let imageData = imageData {
                self?.addToCache(imageData, fileURL: fileURL)
            }
            DispatchQueue.main.async {
                if let imageData = imageData {
                    callback(UIImage(data: imageData))
                } else {
                    callback(nil)
                }
            }
        }
    }
    
    func getImageCacheDirectoryPath() -> URL {
        let arrayPaths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        var cacheDirectoryPath = arrayPaths[0]
        cacheDirectoryPath.appendPathComponent("ImageCache/")
        return cacheDirectoryPath
    }
    
    private func loadFromNetwork(imageUrl: URL, callback: @escaping (Data?) -> Void) {
        DispatchQueue.global().async {
            self.getData(from: imageUrl) { data, response, error in
                if error == nil {
                    callback(data)
                } else {
                    callback(nil)

                }
            }
        }
    }
    
    private func addToCache(_ imageData: Data, fileURL: URL) {
        queue.async(flags: .barrier) {
            try? imageData.write(to: fileURL)
        }
    }
    
    private func readFromCache(from url: URL, callback: @escaping (UIImage?) -> Void) {
        queue.async { [weak self] in
            guard let imageData = self?.fileManager.contents(atPath: url.path) else {
                DispatchQueue.main.async {
                    callback(nil)
                }
                return
            }
            DispatchQueue.main.async {
                callback(UIImage(data: imageData))
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
