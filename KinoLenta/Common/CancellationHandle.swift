import Foundation
import UIKit

final class CancellationHandle {
    private var callbacks = [() -> Void]()
    private(set) var isCancelled = false {
        didSet {
            while !callbacks.isEmpty {
                callbacks.remove(at: 0)()
            }
        }
    }

    func cancel() {
        isCancelled = true
    }

    func onCancelled(callback: @escaping () -> Void) {
        callbacks.append(callback)
    }
}
