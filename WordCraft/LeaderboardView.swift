import SwiftUI

struct LeaderboardView: View {
    var navigateTo: (ContentView.Screen) -> Void
    
    @StateObject private var gameManager = GameManager.shared
    @State private var selectedFilter = "All Time"
    @State private var leaderboard: [LeaderboardEntry] = []
    
    let filterOptions = ["All Time", "This Week", "Today"]
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        navigateTo(.mainMenu)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 5) {
                        Text("🏆")
                            .font(.title)
                        Text("Leaderboard")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Invisible button for balance
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.clear)
                        .padding()
                }
                .padding(.top, 20)
                
                // Filter
                HStack(spacing: 10) {
                    Text("Filter:")
                        .foregroundColor(.white)
                    
                    Menu {
                        ForEach(filterOptions, id: \.self) { option in
                            Button(option) {
                                selectedFilter = option
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedFilter)
                                .foregroundColor(.white)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.2))
                        )
                    }
                }
                .padding()
                
                // Leaderboard list
                ScrollView {
                    if filteredLeaderboard.isEmpty {
                        VStack(spacing: 20) {
                            Text("🎮")
                                .font(.system(size: 60))
                                .padding(.top, 60)

                            Text("No scores yet!")
                                .font(.title2)
                                .foregroundColor(.white)

                            Text(selectedFilter == "All Time" ? "Play a game to see your score here" : "No scores for this time period")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        VStack(spacing: 15) {
                            ForEach(Array(filteredLeaderboard.enumerated()), id: \.offset) { index, entry in
                                LeaderboardRow(
                                    rank: index + 1,
                                    entry: entry,
                                    isCurrentUser: entry.name == gameManager.playerName
                                )
                            }
                        }
                        .padding()
                    }
                }
                
                // Back button
                Button(action: {
                    navigateTo(.mainMenu)
                }) {
                    Text("Back to Menu")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple.opacity(0.5))
                        .cornerRadius(15)
                }
                .padding()
            }
        }
        .onAppear {
            loadLeaderboard()
        }
    }
    
    var filteredLeaderboard: [LeaderboardEntry] {
        switch selectedFilter {
        case "Today":
            return leaderboard.filter { Calendar.current.isDateInToday($0.date) }
        case "This Week":
            guard let weekInterval = Calendar.current.dateInterval(of: .weekOfYear, for: Date()) else {
                return leaderboard
            }
            return leaderboard.filter { $0.date >= weekInterval.start }
        default:
            return leaderboard
        }
    }

    func loadLeaderboard() {
        leaderboard = gameManager.loadLeaderboard()
    }
}

struct LeaderboardRow: View {
    let rank: Int
    let entry: LeaderboardEntry
    let isCurrentUser: Bool
    
    var medalEmoji: String {
        switch rank {
        case 1: return "👑"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return ""
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: entry.date)
    }
    
    var body: some View {
        HStack(spacing: 15) {
            // Rank
            ZStack {
                Circle()
                    .fill(isCurrentUser ? Color.yellow.opacity(0.3) : Color.white.opacity(0.2))
                    .frame(width: 45, height: 45)
                
                if rank <= 3 {
                    Text(medalEmoji)
                        .font(.title2)
                } else {
                    Text("\(rank).")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            
            // Name and date
            VStack(alignment: .leading, spacing: 5) {
                Text(entry.name)
                    .font(.headline)
                    .foregroundColor(isCurrentUser ? .yellow : .white)
                    .fontWeight(isCurrentUser ? .bold : .regular)
                
                Text(formattedDate)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            // Score
            Text("\(entry.score)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(isCurrentUser ? .yellow : .white)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(isCurrentUser ? Color.yellow.opacity(0.2) : Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isCurrentUser ? Color.yellow : Color.clear, lineWidth: 2)
                )
        )
    }
}

#Preview {
    LeaderboardView(navigateTo: { _ in })
}
