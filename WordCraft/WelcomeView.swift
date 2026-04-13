import SwiftUI

struct WelcomeView: View {
    var navigateTo: (ContentView.Screen) -> Void

    @StateObject private var gameManager = GameManager.shared
    @State private var nameText = ""
    @FocusState private var isNameFocused: Bool

    var isNameValid: Bool {
        nameText.count >= 3 && nameText.count <= 15
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                // Title
                VStack(spacing: 10) {
                    Text("🎯")
                        .font(.system(size: 80))

                    Text("WordCraft")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Welcome, word wizard!")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                }

                Spacer()

                // Name entry
                VStack(spacing: 20) {
                    Text("What should we call you?")
                        .font(.headline)
                        .foregroundColor(.white)

                    TextField("Enter your name", text: $nameText)
                        .textFieldStyle(.plain)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        .focused($isNameFocused)
                        .padding(.horizontal, 40)

                    if !nameText.isEmpty && !isNameValid {
                        Text("Name must be 3-15 characters")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }

                // Continue button
                Button(action: {
                    gameManager.savePlayerName(nameText)
                    gameManager.setHasLaunched()
                    navigateTo(.mainMenu)
                }) {
                    Text("Let's Play!")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isNameValid ? Color.green : Color.gray)
                        .cornerRadius(15)
                }
                .disabled(!isNameValid)
                .padding(.horizontal, 40)

                Spacer()
            }
        }
        .onAppear {
            isNameFocused = true
        }
    }
}

#Preview {
    WelcomeView(navigateTo: { _ in })
}
