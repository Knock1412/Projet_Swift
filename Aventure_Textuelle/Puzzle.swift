import Foundation

struct Puzzle: Codable {
    let id: String
    let roomID: String
    let description: String
    let solutionItemID: String
    var isSolved: Bool
}
