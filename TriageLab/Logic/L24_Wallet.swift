import Foundation

// Case C24. Prepaid balance for lab tests.
actor Wallet {
    private(set) var balance = 100

    func buy(price: Int) async -> Bool {
        guard balance >= price else { return false }
        try? await Task.sleep(nanoseconds: 200_000_000)
        balance -= price
        return true
    }
}

enum WalletLab {
    static func buyTwoAtOnce() async -> (results: [Bool], balance: Int) {
        let wallet = Wallet()
        async let first = wallet.buy(price: 80)
        async let second = wallet.buy(price: 80)
        let results = await [first, second]
        let balance = await wallet.balance
        Log.info(.lab, "wallet_lab", ["balance": String(balance)])
        return (results: results, balance: balance)
    }
}
