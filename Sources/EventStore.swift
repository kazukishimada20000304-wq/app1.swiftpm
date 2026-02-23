import Foundation
import UIKit

@MainActor
@Observable
class EventStore {
    var events: [BabyEvent] = []

    private let eventsKey = "babyEvents"

    init() {
        load()
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
}
