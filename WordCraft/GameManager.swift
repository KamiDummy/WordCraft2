import Foundation

// Leaderboard entry structure
struct LeaderboardEntry: Codable, Identifiable {
    let id: UUID
    let name: String
    let score: Int
    let date: Date
    let level: GameLevel
    
    init(name: String, score: Int, level: GameLevel) {
        self.id = UUID()
        self.name = name
        self.score = score
        self.date = Date()
        self.level = level
    }
}

// Game progress tracker
class GameManager: ObservableObject {
    static let shared = GameManager()
    
    @Published var playerName: String = "YOU"
    @Published var currentScore: Int = 0
    @Published var highScore: Int = 0
    @Published var easyCompleted: Bool = false
    @Published var mediumCompleted: Bool = false
    @Published var hardCompleted: Bool = false
    @Published var hasLaunchedBefore: Bool = false

    private let defaults = UserDefaults.standard
    
    init() {
        loadProgress()
    }
    
    // MARK: - Level Unlock Logic
    
    func isLevelUnlocked(_ level: GameLevel) -> Bool {
        switch level {
        case .easy:
            return true // Always unlocked
        case .medium:
            return easyCompleted // Unlock after completing easy
        case .hard:
            return mediumCompleted // Unlock after completing medium
        }
    }
    
    func completeLevel(_ level: GameLevel) {
        switch level {
        case .easy:
            easyCompleted = true
            defaults.set(true, forKey: "easyCompleted")
        case .medium:
            mediumCompleted = true
            defaults.set(true, forKey: "mediumCompleted")
        case .hard:
            hardCompleted = true
            defaults.set(true, forKey: "hardCompleted")
        }
    }
    
    func getLevelStars(_ level: GameLevel) -> Int {
        switch level {
        case .easy:
            return easyCompleted ? 3 : 0
        case .medium:
            return mediumCompleted ? 3 : 0
        case .hard:
            return hardCompleted ? 3 : 0
        }
    }
    
    // MARK: - Score Management
    
    func updateHighScore(_ score: Int) {
        if score > highScore {
            highScore = score
            defaults.set(score, forKey: "highScore")
        }
    }
    
    // MARK: - Leaderboard Management
    
    func saveScore(_ score: Int, level: GameLevel) {
        var leaderboard = loadLeaderboard()
        let entry = LeaderboardEntry(name: playerName, score: score, level: level)
        leaderboard.append(entry)
        
        // Keep only top 50 scores
        leaderboard.sort { $0.score > $1.score }
        if leaderboard.count > 50 {
            leaderboard = Array(leaderboard.prefix(50))
        }
        
        // Save to UserDefaults
        if let encoded = try? JSONEncoder().encode(leaderboard) {
            defaults.set(encoded, forKey: "leaderboard")
        }
        
        updateHighScore(score)
    }
    
    func loadLeaderboard() -> [LeaderboardEntry] {
        guard let data = defaults.data(forKey: "leaderboard"),
              let leaderboard = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) else {
            return []
        }
        return leaderboard.sorted { $0.score > $1.score }
    }
    
    func getCurrentUserRank() -> Int? {
        let leaderboard = loadLeaderboard()
        return leaderboard.firstIndex { $0.name == playerName && $0.score == highScore }
    }
    
    // MARK: - Persistence
    
    func loadProgress() {
        playerName = defaults.string(forKey: "playerName") ?? "YOU"
        highScore = defaults.integer(forKey: "highScore")
        easyCompleted = defaults.bool(forKey: "easyCompleted")
        mediumCompleted = defaults.bool(forKey: "mediumCompleted")
        hardCompleted = defaults.bool(forKey: "hardCompleted")
        hasLaunchedBefore = defaults.bool(forKey: "hasLaunchedBefore")
    }
    
    func savePlayerName(_ name: String) {
        playerName = name
        defaults.set(name, forKey: "playerName")
    }
    
    func resetProgress() {
        easyCompleted = false
        mediumCompleted = false
        hardCompleted = false
        defaults.set(false, forKey: "easyCompleted")
        defaults.set(false, forKey: "mediumCompleted")
        defaults.set(false, forKey: "hardCompleted")
    }

    func resetAllProgress() {
        resetProgress()
        highScore = 0
        defaults.set(0, forKey: "highScore")
        defaults.removeObject(forKey: "leaderboard")
    }

    func setHasLaunched() {
        hasLaunchedBefore = true
        defaults.set(true, forKey: "hasLaunchedBefore")
    }
}
