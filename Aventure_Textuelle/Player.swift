import Foundation

class Player {
    let name: String
    var inventory: [Item] = []
    var currentRoomID: String
    var score: Int = 0

    init(name: String, startRoomID: String) {
        self.name = name
        self.currentRoomID = startRoomID
    }

    func addItem(_ item: Item) {
        inventory.append(item)
    }

    func hasItem(named itemName: String) -> Bool {
        return inventory.contains { $0.name.lowercased() == itemName.lowercased() }
    }

    func showInventory() {
        print("\nInventaire de \(name) :")
        if inventory.isEmpty {
            print("Votre inventaire est vide.")
        } else {
            for item in inventory {
                print("- \(item.name): \(item.description)")
            }
        }
        print("\nScore: \(score)")
    }

    func useItem(named itemName: String) {
        if hasItem(named: itemName) {
            print("Vous utilisez l’objet \(itemName).")
        } else {
            print("Vous n’avez pas cet objet.")
        }
    }
}
