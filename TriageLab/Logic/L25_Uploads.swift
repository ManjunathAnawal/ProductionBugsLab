import Foundation

// Case C25. Uploads 5 scans one after another.
class AsyncOperation: Operation {
    private var executingFlag = false
    private var finishedFlag = false

    override var isAsynchronous: Bool { true }
    override var isExecuting: Bool { executingFlag }
    override var isFinished: Bool { finishedFlag }

    override func start() {
        if isCancelled {
            finish()
            return
        }
        willChangeValue(forKey: "isExecuting")
        executingFlag = true
        didChangeValue(forKey: "isExecuting")
        main()
    }

    func finish() {
        willChangeValue(forKey: "isExecuting")
        willChangeValue(forKey: "isFinished")
        executingFlag = false
        finishedFlag = true
        didChangeValue(forKey: "isExecuting")
        didChangeValue(forKey: "isFinished")
    }
}

final class UploadOperation: AsyncOperation {
    private let index: Int
    private let onResult: (Int, Bool) -> Void

    init(index: Int, onResult: @escaping (Int, Bool) -> Void) {
        self.index = index
        self.onResult = onResult
    }

    override func main() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
            if self.index == 3 {
                Log.error(.lab, "upload_failed", ["scan": String(self.index)])
                self.onResult(self.index, false)
                return
            }
            Log.info(.lab, "upload_ok", ["scan": String(self.index)])
            self.onResult(self.index, true)
            self.finish()
        }
    }
}

enum UploadLab {
    static func start(onResult: @escaping (Int, Bool) -> Void) -> OperationQueue {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        for index in 1...5 {
            queue.addOperation(UploadOperation(index: index, onResult: onResult))
        }
        return queue
    }
}
