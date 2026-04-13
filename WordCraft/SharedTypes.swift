import Foundation

// Difficulty levels for the game
enum GameLevel: String, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

struct GameResult {
    let score: Int
    let timeBonus: Int
    let wordsSolved: Int
    let totalWords: Int
    let accuracy: Int
    let level: GameLevel
    let didComplete: Bool
    let isNewPersonalBest: Bool
}
