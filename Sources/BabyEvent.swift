import Foundation

struct BabyEvent: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var date: Date
    var comment: String
    var imageFileName: String?
}
