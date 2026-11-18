import Foundation

// Case C30. A crash that you will read as hex addresses, then symbolicate.
enum SymbolPractice {
    @inline(never)
    static func startReport(_ values: [Int]) -> Int {
        return buildSection(values)
    }

    @inline(never)
    private static func buildSection(_ values: [Int]) -> Int {
        return readLastValue(values)
    }

    @inline(never)
    private static func readLastValue(_ values: [Int]) -> Int {
        return values[5]
    }
}
