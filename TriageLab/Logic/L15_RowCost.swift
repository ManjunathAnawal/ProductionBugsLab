import Foundation

// Case C15. Builds the text for one row in the long vitals list.
enum RowCost {
    static func label(_ index: Int) -> String {
        var h = index
        for k in 0..<200_000 {
            h = (h &* 31 &+ k) % 1_000_003
        }
        return "Reading \(index): \(h)"
    }
}
