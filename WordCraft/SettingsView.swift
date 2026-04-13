import SwiftUI

struct SettingsView: View {
    var navigateTo: (ContentView.Screen) -> Void

    @StateObject private var gameManager = GameManager.shared
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    @AppStorage("hintsEnabled") private var hintsEnabled = true
    @State private var nameText = ""
    @State private var showResetAlert = false
    @State private var showNameSaved = false

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
                        Text("⚙️")
                            .font(.title)
                        Text("Settings")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.clear)
                        .padding()
                }
                .padding(.top, 20)

                ScrollView {
                    VStack(spacing: 25) {
                        // Player Name Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Player Name")
                                .font(.headline)
                                .foregroundColor(.white)

                            HStack {
                                TextField("Enter name", text: $nameText)
                                    .textFieldStyle(.plain)
                                    .padding(12)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)

                                Button(action: {
                                    if isNameValid {
                                        gameManager.savePlayerName(nameText)
                                        showNameSaved = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            showNameSaved = false
                                        }
                                    }
                                }) {
                                    Text("Save")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 12)
                                        .background(isNameValid ? Color.green : Color.gray)
                                        .cornerRadius(10)
                                }
                                .disabled(!isNameValid)
                            }

                            if showNameSaved {
                                Text("Name saved!")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            } else if !nameText.isEmpty && !isNameValid {
                                Text("Name must be 3-15 characters")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.1))
                        )

                        // Toggles Section
                        VStack(spacing: 0) {
                            SettingsToggleRow(
                                icon: "iphone.radiowaves.left.and.right",
                                title: "Vibration Feedback",
                                isOn: $hapticsEnabled
                            )

                            Divider().background(Color.white.opacity(0.3))

                            SettingsToggleRow(
                                icon: "lightbulb.fill",
                                title: "Show Hints",
                                isOn: $hintsEnabled
                            )
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.1))
                        )

                        // Reset Section
                        Button(action: {
                            showResetAlert = true
                        }) {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.title3)
                                Text("Reset All Progress")
                                    .font(.headline)
                                Spacer()
                            }
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.red.opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        .alert("Reset Progress", isPresented: $showResetAlert) {
                            Button("Cancel", role: .cancel) {}
                            Button("Reset", role: .destructive) {
                                gameManager.resetAllProgress()
                            }
                        } message: {
                            Text("This will erase all your scores, level progress, and leaderboard data. This cannot be undone.")
                        }
                    }
                    .padding()
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
            nameText = gameManager.playerName
        }
    }
}

struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 30)

            Text(title)
                .font(.body)
                .foregroundColor(.white)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.green)
        }
        .padding()
    }
}

#Preview {
    SettingsView(navigateTo: { _ in })
}
