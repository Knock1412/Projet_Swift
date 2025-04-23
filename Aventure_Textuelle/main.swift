import Foundation

// MARK: - Codes couleurs ANSI et helpers
enum ANSIColor: String {
    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
    case bold = "\u{001B}[1m"
    case reset = "\u{001B}[0m"
}

func colored(_ text: String, _ color: ANSIColor) -> String {
    return color.rawValue + text + ANSIColor.reset.rawValue
}

func prompt(_ message: String) -> String {
    print(colored(message, .cyan), terminator: " ")
    return readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
}

func printTitle(_ text: String) { print(colored(text, .magenta)) }
func printSuccess(_ text: String) { print(colored(text, .green)) }
func printWarning(_ text: String) { print(colored(text, .yellow)) }
func printError(_ text: String) { print(colored(text, .red)) }
func printInfo(_ text: String) { print(colored(text, .blue)) }

// MARK: - Affichage salle & carte
func describeCurrentRoom(for player: Player, in rooms: [String: Room]) {
    guard let room = rooms[player.currentRoomID] else {
        printError("Salle introuvable."); return
    }

    printTitle("\n╔═════════════════════════════════════════════╗")
    printTitle("╠══ Vous êtes dans : \(room.name)")
    printTitle("╚═════════════════════════════════════════════╝")
    printInfo(room.dynamicDescription ?? room.description)

    if let items = room.items, !items.isEmpty {
        print("\n" + colored("Objets présents :", .bold))
        for item in items {
            print("- [\(colored(item.id, .yellow))] \(item.name): \(item.description)")
        }
    }

    print("\n" + colored("Sorties disponibles :", .bold) + " " + colored(room.connections.keys.joined(separator: ", "), .green))
}

func displayMiniMap(for player: Player) {
    let map: [String] = [
        "        [room8]",
        "           ↑",
        "[room6] → [room7]",
        "           ↑",
        "[room4] → [room5]",
        "    ↑",
        "[room3]",
        "    ↑",
        "[room2]",
        "    ↑",
        "[room1]"
    ]

    print("\n" + colored("Carte rapide :", .bold))
    for line in map {
        if line.contains("[\(player.currentRoomID)]") {
            print(colored(line.replacingOccurrences(of: "[\(player.currentRoomID)]", with: "[*\(player.currentRoomID)*]"), .green))
        } else {
            print(colored(line, .white))
        }
    }
}

func applyPuzzleEffects(id: String, in roomMap: inout [String: Room]) -> Bool {
    var changed = false
    switch id {
    case "p1":
        if var room = roomMap["room2"] {
            room.connections["est"] = "room3"
            room.dynamicDescription = """
            Un éboulement bloquait le passage à l'est.
            Une ouverture est maintenant visible derrière les décombres.
            """
            roomMap["room2"] = room
            changed = true
        }
    case "p2":
        if var room = roomMap["room6"] {
            room.connections["est"] = "room7"
            room.dynamicDescription = """
            La salle était inondée.
            Vous avez vidé l'eau avec le seau. Le passage à l'est est désormais accessible.
            """
            roomMap["room6"] = room
            changed = true
        }
    case "p3":
        if var room = roomMap["room7"] {
            room.connections["nord"] = "room8"
            room.dynamicDescription = """
            Le coffre est désormais ouvert.
            Un levier a révélé une issue vers le nord.
            """
            roomMap["room7"] = room
            changed = true
        }
    default:
        break
    }
    return changed
}

// MARK: - Chargement
printTitle("╔══════════════════════════════════════╗")
printTitle("║  Bienvenue dans le jeu d'aventure !  ║")
printTitle("╚══════════════════════════════════════╝")

let savePath = "data/save.json"
let roomPath = "data/map.json"
let puzzlePath = "data/puzzles.json"

var player: Player
var puzzles: [Puzzle] = []

guard let loadedRooms = JSONLoader.loadRooms(from: roomPath) else {
    printError("Impossible de charger les salles."); exit(1)
}
var roomMap = Dictionary(uniqueKeysWithValues: loadedRooms.map { ($0.id, $0) })

if FileManager.default.fileExists(atPath: savePath),
   let save = JSONLoader.loadSaveGame(from: savePath) {

    if prompt("Sauvegarde trouvée. La charger ? (oui/non)").lowercased() == "oui" {
        player = Player(name: save.playerName, startRoomID: save.currentRoomID)
        player.inventory = save.inventory
        player.score = save.score

        puzzles = JSONLoader.loadPuzzles(from: puzzlePath) ?? []
        for i in 0..<puzzles.count where save.solvedPuzzleIDs.contains(puzzles[i].id) {
            puzzles[i].isSolved = true
            _ = applyPuzzleEffects(id: puzzles[i].id, in: &roomMap)
        }
        printSuccess("Partie chargée.")
    } else {
        let name = prompt("Quel est votre nom, aventurier ?")
        player = Player(name: name, startRoomID: "room1")
        puzzles = JSONLoader.loadPuzzles(from: puzzlePath) ?? []
    }
} else {
    let name = prompt("Quel est votre nom, aventurier ?")
    player = Player(name: name, startRoomID: "room1")
    puzzles = JSONLoader.loadPuzzles(from: puzzlePath) ?? []
}

printSuccess("\nBienvenue, \(player.name) !")
describeCurrentRoom(for: player, in: roomMap)

// MARK: - Boucle de jeu
var isPlaying = true
while isPlaying {
    let command = prompt("\nAction (nord/sud/est/ouest, prendre <id>, utiliser <id>, inventaire, carte, aide, quitter) >").lowercased()

    switch command {
    case "inventaire":
        player.showInventory()

    case "carte":
        displayMiniMap(for: player)

    case "aide", "?":
        printInfo("""
        \(colored("Commandes disponibles :", .bold))
        - nord, sud, est, ouest : se déplacer
        - prendre <id>          : ramasser un objet
        - utiliser <id>         : utiliser un objet
        - inventaire            : afficher l'inventaire
        - carte                 : afficher la carte rapide
        - quitter               : sauvegarder et quitter
        """)

    case "quitter":
        let solvedIDs = puzzles.filter(\.isSolved).map(\.id)
        let save = SaveGame(playerName: player.name, currentRoomID: player.currentRoomID, inventory: player.inventory, score: player.score, solvedPuzzleIDs: solvedIDs)
        JSONLoader.saveGame(save, to: savePath)
        printSuccess("Sauvegarde effectuée. À bientôt !")
        isPlaying = false

    case "nord", "sud", "est", "ouest":
        if let next = roomMap[player.currentRoomID]?.connections[command], roomMap[next] != nil {
            player.currentRoomID = next
            describeCurrentRoom(for: player, in: roomMap)
            if player.currentRoomID == "room8" {
                printSuccess("\nFélicitations ! Vous avez trouvé la sortie et terminé l'aventure !")
                printSuccess("Score final : \(player.score)")
                isPlaying = false
            }
        } else {
            printError("Impossible d'aller par là.")
        }

    case let s where s.hasPrefix("prendre "):
        let itemID = String(s.dropFirst("prendre ".count)).lowercased()
        if var room = roomMap[player.currentRoomID], var items = room.items,
           let idx = items.firstIndex(where: { $0.id.lowercased() == itemID }) {
            let item = items.remove(at: idx)
            player.addItem(item)
            room.items = items
            roomMap[player.currentRoomID] = room
            printSuccess("\(item.name) a été ajouté à votre inventaire.")
            describeCurrentRoom(for: player, in: roomMap)
        } else {
            printError("Aucun objet avec cet ID ici.")
        }

    case let s where s.hasPrefix("utiliser "):
        let itemID = String(s.dropFirst("utiliser ".count)).lowercased()
        if player.hasItem(named: itemID) {
            var solved = false
            for i in 0..<puzzles.count where
                puzzles[i].roomID == player.currentRoomID &&
                !puzzles[i].isSolved &&
                puzzles[i].solutionItemID.lowercased() == itemID {

                let puzzle = puzzles[i]
                printSuccess("Énigme résolue : \(puzzle.description)")
                puzzles[i].isSolved = true
                player.score += 10

                if applyPuzzleEffects(id: puzzle.id, in: &roomMap) {
                    printSuccess("\n=== Changement dans la salle ===")
                    describeCurrentRoom(for: player, in: roomMap)
                }
                solved = true
                break
            }
            if !solved {
                printWarning("Vous utilisez \(itemID), mais rien ne se passe.")
            }
        } else {
            printError("Vous ne possédez pas cet objet.")
        }

    default:
        printError("Commande inconnue. Tapez 'aide' pour l'aide.")
    }
}
