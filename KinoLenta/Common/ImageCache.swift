import Foundation
import UIKit
import CommonCrypto

final class ImageCache {
    
    static let shared = ImageCache()
    
    private let fileManager = FileManager()
    private let queue = DispatchQueue(label: "ImageCacheQueue", attributes: .concurrent)
    private lazy var directory = getImageCacheDirectoryPath()
    
    init() {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            try? self.fileManager.createDirectory(
                at: self.getImageCacheDirectoryPath(),
                withIntermediateDirectories: false,
                attributes: nil
            )
        }
    }
    
    
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
                callback(imageData?.toImage())
            }
        }
    }
    
    private func getImageCacheDirectoryPath() -> URL {
        let arrayPaths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        var cacheDirectoryPath = arrayPaths[0]
        cacheDirectoryPath.appendPathComponent("ImageCache/")
        return cacheDirectoryPath
    }
    
    private func loadFromNetwork(imageUrl: URL, callback: @escaping (Data?) -> Void) {
        DispatchQueue.global().async {
            self.getData(from: imageUrl) { data, _, error in
                if let error = error {
                    print(error)
                }
                callback(data)
            }
        }
    }
    
    private func addToCache(_ imageData: Data, fileURL: URL) {
        queue.async(flags: .barrier) {
            try? imageData.write(to: fileURL)
        }
    }
    
    private func readFromCache(from url: URL, callback: @escaping (UIImage?) -> Void) {
        let imageData = self.fileManager.contents(atPath: url.path)
        DispatchQueue.main.async {
            callback(imageData?.toImage())
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
