import Foundation

// Case C12. Builds the daily report.
final class ReportBuilder {
    func buildReport() -> String {
        let semaphore = DispatchSemaphore(value: 0)
        var report = ""
        DispatchQueue.global().async {
            let text = self.collectNumbers()
            DispatchQueue.main.async {
                report = text
                semaphore.signal()
            }
        }
        semaphore.wait()
        return report
    }

    private func collectNumbers() -> String {
        Thread.sleep(forTimeInterval: 0.3)
        return "Daily report ready"
    }
}
