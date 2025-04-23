import Foundation

struct Room: Codable {
    let id: String
    let name: String
    var description: String
    var connections: [String: String]
    var items: [Item]?
    var dynamicDescription: String?
}
