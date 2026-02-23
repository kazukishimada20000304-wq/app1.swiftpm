import Foundation
import UIKit

@MainActor
@Observable
class EventStore {
    var events: [BabyEvent] = []
    var birthDate: Date? {
        didSet { saveBirthDate() }
    }

    private let eventsKey = "babyEvents"
    private let birthDateKey = "birthDate"

    init() {
        load()
        loadBirthDate()
    }

    /// イベント日時点での年齢文字列を返す（生年月日未設定の場合は nil）
    func ageString(at date: Date) -> String? {
        guard let birth = birthDate, date >= birth else { return nil }
        let cal = Calendar.current
        let c = cal.dateComponents([.year, .month, .day], from: birth, to: date)
        guard let y = c.year, let m = c.month, let d = c.day else { return nil }
        if y > 0 {
            return "\(y)歳\(m)ヶ月\(d)日"
        } else if m > 0 {
            return "\(m)ヶ月\(d)日"
        } else {
            return "生後\(d)日"
        }
    }

    func add(_ event: BabyEvent) {
        events.append(event)
        events.sort { $0.date < $1.date }
        save()
    }

    func delete(at offsets: IndexSet) {
        for index in offsets {
            if let fileName = events[index].imageFileName {
                deleteImage(fileName: fileName)
            }
        }
        events.remove(atOffsets: offsets)
        save()
    }

    func saveImage(_ data: Data) -> String {
        let fileName = UUID().uuidString + ".jpg"
        if let url = imageURL(for: fileName) {
            try? data.write(to: url)
        }
        return fileName
    }

    func loadImage(fileName: String) -> UIImage? {
        guard let url = imageURL(for: fileName),
              let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    private func imageURL(for fileName: String) -> URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?.appendingPathComponent(fileName)
    }

    private func deleteImage(fileName: String) {
        guard let url = imageURL(for: fileName) else { return }
        try? FileManager.default.removeItem(at: url)
    }

    private func save() {
        if let data = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(data, forKey: eventsKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: eventsKey),
              let decoded = try? JSONDecoder().decode([BabyEvent].self, from: data)
        else { return }
        events = decoded
    }

    private func saveBirthDate() {
        if let date = birthDate {
            UserDefaults.standard.set(date, forKey: birthDateKey)
        } else {
            UserDefaults.standard.removeObject(forKey: birthDateKey)
        }
    }

    private func loadBirthDate() {
        birthDate = UserDefaults.standard.object(forKey: birthDateKey) as? Date
    }
}
