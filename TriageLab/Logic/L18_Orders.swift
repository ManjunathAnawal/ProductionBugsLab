import Foundation

// Case C18. Orders a medicine refill.
final class OrderServer {
    static let shared = OrderServer()
    private let lock = NSLock()
    private(set) var orders = 0

    func create() -> Int {
        lock.lock()
        orders += 1
        let number = orders
        lock.unlock()
        return number
    }

    func reset() {
        lock.lock()
        orders = 0
        lock.unlock()
    }
}

final class OrderService {
    func submit(completion: @escaping (Int) -> Void) {
        Log.info(.network, "order_submit")
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let number = OrderServer.shared.create()
            Log.info(.network, "order_created", ["order": String(number)])
            DispatchQueue.main.async { completion(number) }
        }
    }
}
