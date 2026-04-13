import SwiftUI

struct HowToPlayView: View {
    var navigateTo: (ContentView.Screen) -> Void
    
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
                        Text("📖")
                            .font(.title)
                        Text("How to Play")
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
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        // Instructions
                        InstructionCard(
                            number: "1",
                            title: "Tap scrambled letters",
                            description: "Select letters in order to form the target word",
                            icon: "hand.tap.fill"
                        )
                        
                        InstructionCard(
                            number: "2",
                            title: "Submit your answer",
                            description: "Press submit before time runs out to check if you're correct",
                            icon: "checkmark.circle.fill"
                        )
                        
                        InstructionCard(
                            number: "3",
                            title: "Earn points for:",
                            description: """
                            • Correct answers: +100
                            • Speed bonus: +50
                            • No hints used: +25
                            • Combo streak: +10
                            """,
                            icon: "star.fill"
                        )
                        
                        InstructionCard(
                            number: "4",
                            title: "Three difficulty levels",
                            description: "Progress through Easy, Medium, and Hard levels. Complete one to unlock the next!",
                            icon: "chart.line.uptrend.xyaxis"
                        )
                        
                        InstructionCard(
                            number: "5",
                            title: "Use hints wisely!",
                            description: "Each hint costs -10 points but reveals clues about the word",
                            icon: "lightbulb.fill"
                        )
                        
                        // Time limits info
                        VStack(alignment: .leading, spacing: 15) {
                            Text("⏱️ Time Limits")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                TimeLimitRow(level: "Easy", time: "45 seconds", color: .green)
                                TimeLimitRow(level: "Medium", time: "30 seconds", color: .orange)
                                TimeLimitRow(level: "Hard", time: "20 seconds", color: .red)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.15))
                        )
                        
                        // Lives system
                        VStack(alignment: .leading, spacing: 15) {
                            Text("❤️ Lives System")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("You start with 3 lives. Lose a life for each wrong answer or timeout. Game over when you run out of lives!")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.15))
                        )
                        
                        // Pro tips
                        VStack(alignment: .leading, spacing: 15) {
                            Text("💡 Pro Tips")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                TipRow(tip: "Look for common letter patterns")
                                TipRow(tip: "Start with vowels to find the word structure")
                                TipRow(tip: "Save hints for the hardest words")
                                TipRow(tip: "Speed matters! Faster answers = more points")
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.yellow.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.yellow, lineWidth: 1)
                                )
                        )
                    }
                    .padding()
                }
                
                // Got it button
                Button(action: {
                    navigateTo(.mainMenu)
                }) {
                    Text("Got it!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(15)
                }
                .padding()
            }
        }
    }
}

struct InstructionCard: View {
    let number: String
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            // Number circle
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Text(number)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.yellow)
                    
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.15))
        )
    }
}

struct TimeLimitRow: View {
    let level: String
    let time: String
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(level)
                .font(.body)
                .foregroundColor(.white)
            
            Spacer()
            
            Text(time)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

struct TipRow: View {
    let tip: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("•")
                .foregroundColor(.yellow)
                .font(.headline)
            
            Text(tip)
                .font(.body)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    HowToPlayView(navigateTo: { _ in })
}
