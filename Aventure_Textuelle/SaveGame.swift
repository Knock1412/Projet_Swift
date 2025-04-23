import Foundation

struct SaveGame: Codable {
    let playerName: String
    let currentRoomID: String
    let inventory: [Item]
    let score: Int
    let solvedPuzzleIDs: [String]
}
