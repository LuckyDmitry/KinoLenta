import CommonCrypto
import Foundation
import UIKit

extension URL {
    func nameForCaching() -> String {
        let data = Data(self.absoluteString.utf8)
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash).hexDescription
    }
}
