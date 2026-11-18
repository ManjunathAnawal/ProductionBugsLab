import SwiftUI

// ---------- C17 ----------
struct C17View: View {
    @State private var phones = 100
    @State private var result = "-"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("The server is down. Many phones ask for data at the same time.")
            Stepper("Phones: \(phones)", value: $phones, in: 10...500, step: 10)
            Button("Simulate outage") {
                let count = phones
                Task.detached {
                    let requests = RetryLab.simulate(phones: count)
                    await MainActor.run {
                        result = "\(count) phones sent \(requests) requests to the server."
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            Text(result)
        }
    }
}

// ---------- C18 ----------
struct C18View: View {
    private let service = OrderService()
    @State private var message = "No order yet"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Order a refill. Tap the button twice quickly, like a nervous user.")
            Button("Order refill") {
                service.submit { number in
                    message = "Last order number: \(number). Orders on server: \(OrderServer.shared.orders)"
                }
            }
            .buttonStyle(.borderedProminent)
            Text(message)
            Button("Reset server") {
                OrderServer.shared.reset()
                message = "No order yet"
            }
            .buttonStyle(.bordered)
        }
    }
}

// ---------- C19 ----------
struct C19View: View {
    @State private var result = "-"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("The access token is old. Five screens ask for data at the same moment.")
            Button("Fire 5 API calls at once") {
                Task.detached {
                    let outcome = AuthLab.fiveParallelCalls()
                    await MainActor.run {
                        result = "OK: \(outcome.ok). Failed: \(outcome.failed). Logged out: \(outcome.loggedOut)"
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            Text(result)
        }
    }
}

// ---------- C20 ----------
struct C20View: View {
    @State private var heartRate = "-"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Pretend the app was just updated. Install last week's saved file, then open the dashboard.")
            Button("Install cache from old app version") {
                VitalsCache.installOldVersionFile()
            }
            .buttonStyle(.bordered)
            Button("Open dashboard") {
                heartRate = String(VitalsCache.loadHeartRate())
            }
            .buttonStyle(.borderedProminent)
            Text("Heart rate: \(heartRate)")
        }
    }
}
