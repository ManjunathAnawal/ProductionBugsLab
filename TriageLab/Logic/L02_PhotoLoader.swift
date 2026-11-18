import Foundation

// Case C02. Loads patient photos for the gallery.
struct DecodedPhoto {
    let width: Int
    let height: Int
    let pixels: [UInt8]
}

enum PhotoLoader {
    static func loadAll(count: Int) -> [DecodedPhoto] {
        var photos: [DecodedPhoto] = []
        for index in 0..<count {
            photos.append(decode(index: index))
        }
        Log.info(.lab, "photos_loaded", ["count": String(count)])
        return photos
    }

    static func decode(index: Int) -> DecodedPhoto {
        let width = 4032
        let height = 3024
        let pixels = [UInt8](repeating: UInt8(index % 255), count: width * height * 4)
        return DecodedPhoto(width: width, height: height, pixels: pixels)
    }
}
