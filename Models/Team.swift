import Foundation

struct Team {
    let name: String
    let players: [String]
    let coach: String

    init(name: String, players: [String], coach: String) {
        self.name = name
        self.players = players
        self.coach = coach
    }
}