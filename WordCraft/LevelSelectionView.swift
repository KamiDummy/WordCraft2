import SwiftUI

struct LevelSelectionView: View {
    var navigateTo: (ContentView.Screen) -> Void
    var selectLevel: (GameLevel) -> Void
    
    @StateObject private var gameManager = GameManager.shared
    
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
                    
                    Text("Choose Your Level")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Invisible button for balance
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.clear)
                        .padding()
                }
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Easy Level
                        LevelCard(
                            emoji: "🌱",
                            title: "EASY",
                            description: "4-5 letter words",
                            status: gameManager.easyCompleted ? "Completed" : "Start Here",
                            stars: gameManager.getLevelStars(.easy),
                            isLocked: !gameManager.isLevelUnlocked(.easy),
                            color: .green
                        ) {
                            if gameManager.isLevelUnlocked(.easy) {
                                selectLevel(.easy)
                                navigateTo(.gameplay)
                            }
                        }
                        
                        // Medium Level
                        LevelCard(
                            emoji: "🔥",
                            title: "MEDIUM",
                            description: "6-7 letter words",
                            status: gameManager.isLevelUnlocked(.medium) ? (gameManager.mediumCompleted ? "Completed" : "In Progress") : "Complete Easy First",
                            stars: gameManager.getLevelStars(.medium),
                            isLocked: !gameManager.isLevelUnlocked(.medium),
                            color: .orange
                        ) {
                            if gameManager.isLevelUnlocked(.medium) {
                                selectLevel(.medium)
                                navigateTo(.gameplay)
                            }
                        }
                        
                        // Hard Level
                        LevelCard(
                            emoji: "💎",
                            title: "HARD",
                            description: "8+ letter words",
                            status: gameManager.isLevelUnlocked(.hard) ? (gameManager.hardCompleted ? "Completed" : "Challenge Mode") : "Complete Medium First",
                            stars: gameManager.getLevelStars(.hard),
                            isLocked: !gameManager.isLevelUnlocked(.hard),
                            color: .red
                        ) {
                            if gameManager.isLevelUnlocked(.hard) {
                                selectLevel(.hard)
                                navigateTo(.gameplay)
                            }
                        }
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

struct LevelCard: View {
    let emoji: String
    let title: String
    let description: String
    let status: String
    let stars: Int
    let isLocked: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                // Emoji
                Text(emoji)
                    .font(.system(size: 60))
                    .opacity(isLocked ? 0.3 : 1.0)
                
                // Title
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(isLocked ? .gray : .white)
                
                // Description
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(isLocked ? .gray : .white.opacity(0.8))
                
                // Status or Lock
                if isLocked {
                    HStack(spacing: 5) {
                        Image(systemName: "lock.fill")
                        Text("Locked")
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                } else {
                    // Stars
                    HStack(spacing: 5) {
                        ForEach(0..<3) { index in
                            Image(systemName: index < stars ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                    }
                    .font(.caption)
                    
                    Text(status)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isLocked ? Color.gray.opacity(0.3) : color.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isLocked ? Color.gray : color, lineWidth: 2)
                    )
            )
        }
        .disabled(isLocked)
    }
}

#Preview {
    LevelSelectionView(
        navigateTo: { _ in },
        selectLevel: { _ in }
    )
}
