import Foundation
#if canImport(Darwin)
import Darwin
import os
#endif

// =====================================================================================
// MEMORY USED = what the app uses now.   MEMORY LEFT = room before iOS closes the app.
// Memory left is 0 on the Simulator. Use a real phone for that number.
// =====================================================================================
enum MemoryProbe {
    static func memoryLeftMB() -> Int {
        #if canImport(Darwin)
        return Int(os_proc_available_memory()) / 1_048_576
        #else
        return 0
        #endif
    }

    static func memoryUsedMB() -> Int {
        #if canImport(Darwin)
        var info = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size) / 4
        let result = withUnsafeMutablePointer(to: &info) { pointer in
            pointer.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { rebound in
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), rebound, &count)
            }
        }
        guard result == KERN_SUCCESS else { return -1 }
        return Int(info.phys_footprint) / 1_048_576
        #else
        return -1
        #endif
    }
}

/// Every 10 seconds: save the latest memory numbers (so the NEXT launch can read them after a silent kill).
final class MemorySampler: @unchecked Sendable {
    static let shared = MemorySampler()
    private var started = false

    func start() {
        guard !started else { return }
        started = true
        let thread = Thread(block: {
            while true {
                MemorySampler.shared.sample()
                Thread.sleep(forTimeInterval: 5)
            }
        })
        thread.name = "TriageLab.MemorySampler"
        thread.qualityOfService = .utility
        thread.start()
    }

    func sample() {
        RunTracker.heartbeat(
            screen: AppContext.shared.currentScreen,
            memoryLeftMB: MemoryProbe.memoryLeftMB(),
            memoryUsedMB: MemoryProbe.memoryUsedMB())
    }
}

/// Holds real memory in 50 MB steps, so you can watch the numbers move.
final class MemoryBallast: @unchecked Sendable {
    static let shared = MemoryBallast()
    private let lock = NSLock()
    private var blocks: [[UInt8]] = []

    var totalMB: Int {
        lock.lock()
        defer { lock.unlock() }
        return blocks.count * 50
    }

    func allocate50MB() {
        let block = [UInt8](repeating: 0xAB, count: 50 * 1_024 * 1_024)   // filled = real memory
        lock.lock()
        blocks.append(block)
        lock.unlock()
    }

    func releaseAll() {
        lock.lock()
        blocks.removeAll()
        lock.unlock()
    }
}
