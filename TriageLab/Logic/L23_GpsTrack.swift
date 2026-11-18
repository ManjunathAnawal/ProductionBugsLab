import Foundation

// Case C23. Walking distance from GPS fixes.
struct GpsFix {
    let lat: Double
    let lon: Double
    let accuracy: Double
    let ageSeconds: Double
}

enum GpsTrack {
    static let fixes: [GpsFix] = [
        GpsFix(lat: 40.7128, lon: -74.0060, accuracy: 65, ageSeconds: 3600),
        GpsFix(lat: 12.9716, lon: 77.5946, accuracy: 20, ageSeconds: 1),
        GpsFix(lat: 12.9718, lon: 77.5948, accuracy: 15, ageSeconds: 1),
        GpsFix(lat: 13.5000, lon: 77.9000, accuracy: 800, ageSeconds: 1),
        GpsFix(lat: 12.9722, lon: 77.5952, accuracy: -1, ageSeconds: 1),
        GpsFix(lat: 12.9724, lon: 77.5954, accuracy: 10, ageSeconds: 1)
    ]

    static func totalKm() -> Double {
        var total = 0.0
        for index in 1..<fixes.count {
            total += distanceKm(fixes[index - 1], fixes[index])
        }
        return total
    }

    private static func distanceKm(_ a: GpsFix, _ b: GpsFix) -> Double {
        let r = 6371.0
        let dLat = (b.lat - a.lat) * Double.pi / 180
        let dLon = (b.lon - a.lon) * Double.pi / 180
        let x = sin(dLat / 2) * sin(dLat / 2)
            + cos(a.lat * Double.pi / 180) * cos(b.lat * Double.pi / 180) * sin(dLon / 2) * sin(dLon / 2)
        return r * 2 * atan2(sqrt(x), sqrt(1 - x))
    }
}
