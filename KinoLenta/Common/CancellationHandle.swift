import Foundation
import UIKit

// TODO(stonespb): Change to actor/@MainActor
final class CancellationHandle {
    private var callbacks = [() -> Void]()
    private(set) var isCancelled = false {
        didSet {
            assert(Thread.isMainThread)
            while !callbacks.isEmpty {
                callbacks.remove(at: 0)()
            }
        }
    }

    func cancel() {
        assert(Thread.isMainThread)
        isCancelled = true
    }

    func onCancelled(callback: @escaping () -> Void) {
        assert(Thread.isMainThread)
        callbacks.append(callback)
    }
}
