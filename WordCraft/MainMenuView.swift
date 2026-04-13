import SwiftUI

struct MainMenuView: View {
    var navigateTo: (ContentView.Screen) -> Void
    
    @StateObject private var gameManager = GameManager.shared
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Title
                VStack(spacing: 10) {
                    Text("🎯")
                        .font(.system(size: 80))
                    
                    Text("WordCraft")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Daily Word Puzzle Challenge")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                // Menu buttons
                VStack(spacing: 20) {
                    MenuButton(title: "Play Game", icon: "play.fill") {
                        navigateTo(.levelSelection)
                    }
                    
                    MenuButton(title: "Leaderboard", icon: "trophy.fill") {
                        navigateTo(.leaderboard)
                    }
                    
                    MenuButton(title: "How to Play", icon: "book.fill") {
                        navigateTo(.howToPlay)
                    }
                    
                    MenuButton(title: "Settings", icon: "gearshape.fill") {
                        navigateTo(.settings)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Personal best
                VStack(spacing: 5) {
                    Text("Your Best Score")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(gameManager.highScore > 0 ? "\(gameManager.highScore) pts" : "No scores yet")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(gameManager.highScore > 0 ? .yellow : .white.opacity(0.5))
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct MenuButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.2))
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
            )
        }
    }
}

#Preview {
    MainMenuView(navigateTo: { _ in })
}
