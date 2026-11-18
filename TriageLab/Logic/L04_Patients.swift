import Foundation

// Case C04. Patient list from the hospital server.
struct Doctor: Codable {
    let name: String
}

struct PatientRecord: Codable {
    let id: Int
    let name: String
    let doctor: Doctor?
}

struct PatientSummary: Identifiable {
    let id: Int
    let name: String
}

final class PatientService {
    private let records: [PatientRecord]

    init() {
        let json = """
        [
          {"id": 1, "name": "A. Rao", "doctor": {"name": "Dr. Mehta"}},
          {"id": 2, "name": "B. Singh", "doctor": {"name": "Dr. Iyer"}},
          {"id": 3, "name": "C. Das"}
        ]
        """
        records = (try? JSONDecoder().decode([PatientRecord].self, from: Data(json.utf8))) ?? []
    }

    func patientNames() -> [PatientSummary] {
        records.map { PatientSummary(id: $0.id, name: $0.name) }
    }

    func doctorName(forPatient id: Int) -> String {
        let record = records.first { $0.id == id }!
        return record.doctor!.name
    }
}
