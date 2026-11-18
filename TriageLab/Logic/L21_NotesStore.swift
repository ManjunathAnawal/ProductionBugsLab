import Foundation

// Case C21. Saves the nurse's note.
struct Note: Codable {
    let text: String
    let savedAt: Double
}

enum NotesStore {
    static var url: URL {
        let base = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("note.json")
    }

    static func save(_ text: String, crashHalfway: Bool) {
        Log.info(.data, "note_save_start", ["chars": String(text.count)])
        let note = Note(text: text, savedAt: Date().timeIntervalSince1970)
        let data = (try? JSONEncoder().encode(note)) ?? Data()
        let firstHalf = data.prefix(data.count / 2)
        try? Data(firstHalf).write(to: url)
        if crashHalfway {
            LogStore.shared.flush()
            fatalError("App ended while saving")
        }
        try? data.write(to: url)
        Log.info(.data, "note_save_end")
    }

    static func load() -> String? {
        guard let data = try? Data(contentsOf: url),
              let note = try? JSONDecoder().decode(Note.self, from: data) else { return nil }
        return note.text
    }
}
