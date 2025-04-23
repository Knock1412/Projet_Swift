import Foundation

class JSONLoader {
    static func loadRooms(from filename: String) -> [Room]? {
        let url = URL(fileURLWithPath: filename)

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let rooms = try decoder.decode([Room].self, from: data)
            return rooms
        } catch {
            print("Erreur lors du chargement des salles : \(error)")
            return nil
        }
    }

    static func loadPuzzles(from filename: String) -> [Puzzle]? {
        let url = URL(fileURLWithPath: filename)
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([Puzzle].self, from: data)
        } 
        catch {
            print("Erreur de chargement des énigmes : \(error)")
            return nil
        }
    }
        static func saveGame(_ save: SaveGame, to path: String) {
    let url = URL(fileURLWithPath: path)
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(save)
        try data.write(to: url)
        print("Partie sauvegardée.")
    } catch {
        print("Erreur lors de la sauvegarde : \(error)")
    }
}

    static func loadSaveGame(from path: String) -> SaveGame? {
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(SaveGame.self, from: data)
        } 
        catch {
            print("Erreur lors du chargement de la sauvegarde : \(error)")
            return nil
        }
    }

}
