import SwiftUI

struct ContentView: View {
    @StateObject private var gameManager = GameManager.shared
    @State private var currentScreen: Screen = .mainMenu
    @State private var selectedLevel: GameLevel = .easy
    @State private var gameResult: GameResult?
    
    enum Screen {
        case mainMenu
        case levelSelection
        case gameplay
        case leaderboard
        case howToPlay
        case gameOver
        case settings
        case welcomeName
    }
    
    var body: some View {
        ZStack {
            switch currentScreen {
            case .mainMenu:
                MainMenuView(navigateTo: { screen in
                    withAnimation {
                        currentScreen = screen
                    }
                })
            case .levelSelection:
                LevelSelectionView(
                    navigateTo: { screen in
                        withAnimation {
                            currentScreen = screen
                        }
                    },
                    selectLevel: { level in
                        selectedLevel = level
                    }
                )
            case .gameplay:
                GamePlayView(
                    level: selectedLevel,
                    navigateTo: { screen in
                        withAnimation {
                            currentScreen = screen
                        }
                    },
                    onGameEnd: { result in
                        gameResult = result
                        withAnimation {
                            currentScreen = .gameOver
                        }
                    }
                )
            case .leaderboard:
                LeaderboardView(navigateTo: { screen in
                    withAnimation {
                        currentScreen = screen
                    }
                })
            case .howToPlay:
                HowToPlayView(navigateTo: { screen in
                    withAnimation {
                        currentScreen = screen
                    }
                })
            case .gameOver:
                GameOverView(result: gameResult, navigateTo: { screen in
                    withAnimation {
                        currentScreen = screen
                    }
                })
            case .settings:
                SettingsView(navigateTo: { screen in
                    withAnimation {
                        currentScreen = screen
                    }
                })
            case .welcomeName:
                WelcomeView(navigateTo: { screen in
                    withAnimation {
                        currentScreen = screen
                    }
                })
            }
        }
        .onAppear {
            if !gameManager.hasLaunchedBefore {
                currentScreen = .welcomeName
            }
        }
    }
}

#Preview {
    ContentView()
}
