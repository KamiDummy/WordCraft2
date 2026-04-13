import SwiftUI

struct GameOverView: View {
    let result: GameResult?
    var navigateTo: (ContentView.Screen) -> Void

    @State private var displayedScore = 0
    @State private var animationComplete = false

    private var score: Int { result?.score ?? 0 }
    private var timeBonus: Int { result?.timeBonus ?? 0 }
    private var wordsSolved: Int { result?.wordsSolved ?? 0 }
    private var totalWords: Int { result?.totalWords ?? 10 }
    private var accuracy: Int { result?.accuracy ?? 0 }
    private var didComplete: Bool { result?.didComplete ?? false }
    private var isNewPersonalBest: Bool { result?.isNewPersonalBest ?? false }

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: didComplete
                    ? [Color.green.opacity(0.6), Color.blue.opacity(0.6)]
                    : [Color.red.opacity(0.6), Color.orange.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
            VStack(spacing: 25) {
                // Title area
                Text(didComplete ? "🎉" : "😔")
                    .font(.system(size: 80))
                    .padding(.top, 20)

                Text(didComplete ? "Level Complete!" : "Game Over")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                // Score breakdown
                VStack(spacing: 15) {
                    ScoreRow(label: "Base Score:", value: "\(displayedScore)")
                    ScoreRow(label: "Time Bonus:", value: "+\(timeBonus)", isBonus: true)

                    Divider()
                        .background(Color.white)
                        .padding(.horizontal, 40)

                    HStack {
                        Text("Total:")
                            .font(.title)
                            .foregroundColor(.white)

                        Spacer()

                        Text("\(score) points")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.2))
                )
                .padding(.horizontal, 30)

                // Statistics
                VStack(spacing: 15) {
                    StatRow(icon: "checkmark.circle.fill", label: "Words Solved:", value: "\(wordsSolved)/\(totalWords)", color: .green)
                    StatRow(icon: "target", label: "Accuracy:", value: "\(accuracy)%", color: .blue)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 40)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.2))
                )
                .padding(.horizontal, 30)

                // Achievement badge (only if new personal best)
                if isNewPersonalBest {
                    VStack(spacing: 10) {
                        Text("🏆")
                            .font(.system(size: 50))
                        Text("New Personal Best!")
                            .font(.headline)
                            .foregroundColor(.yellow)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.yellow.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.yellow, lineWidth: 2)
                            )
                    )
                    .padding(.horizontal, 30)
                }

                // Action buttons
                VStack(spacing: 15) {
                    if didComplete {
                        ActionButton(title: "Next Level", icon: "arrow.right.circle.fill", color: .green) {
                            navigateTo(.levelSelection)
                        }
                    }

                    ActionButton(title: "Play Again", icon: "arrow.clockwise.circle.fill", color: .blue) {
                        navigateTo(.levelSelection)
                    }

                    ActionButton(title: "Main Menu", icon: "house.circle.fill", color: .purple) {
                        navigateTo(.mainMenu)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
            .padding(.top, 10)
            }
        }
        .onAppear {
            animateScore()
        }
    }

    func animateScore() {
        let baseScore = score - timeBonus
        let steps = 20
        let stepValue = max(1, baseScore / steps)
        var current = 0

        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            current += stepValue
            if current >= baseScore {
                displayedScore = baseScore
                timer.invalidate()
            } else {
                displayedScore = current
            }
        }
    }
}

struct ScoreRow: View {
    let label: String
    let value: String
    var isBonus: Bool = false

    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.white)

            Spacer()

            Text(value)
                .font(.headline)
                .foregroundColor(isBonus ? .green : .white)
        }
        .padding(.horizontal, 40)
    }
}

struct StatRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(label)
                .font(.subheadline)
                .foregroundColor(.white)

            Spacer()

            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.headline)

                Spacer()

                Image(systemName: icon)
                    .font(.title3)
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .cornerRadius(15)
        }
    }
}

#Preview {
    GameOverView(result: GameResult(
        score: 850,
        timeBonus: 50,
        wordsSolved: 8,
        totalWords: 10,
        accuracy: 80,
        level: .easy,
        didComplete: true,
        isNewPersonalBest: true
    ), navigateTo: { _ in })
}
