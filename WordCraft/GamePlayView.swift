import SwiftUI
import UIKit

struct GamePlayView: View {
    let level: GameLevel
    var navigateTo: (ContentView.Screen) -> Void
    var onGameEnd: (GameResult) -> Void

    @StateObject private var gameManager = GameManager.shared
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    @AppStorage("hintsEnabled") private var hintsEnabled = true

    @State private var currentWordIndex = 0
    @State private var words: [WordPuzzle] = []
    @State private var scrambledLetters: [String] = []
    @State private var selectedLetters: [String] = []
    @State private var usedIndices: Set<Int> = []
    @State private var timeRemaining = 45
    @State private var score = 0
    @State private var lives = 3
    @State private var hintUsed = false
    @State private var showHint = false
    @State private var timer: Timer?
    @State private var feedbackMessage = ""
    @State private var showFeedback = false
    @State private var feedbackColor = Color.green

    // Game stats for end screen
    @State private var wordsSolved = 0
    @State private var totalAttempts = 0
    @State private var totalTimeBonus = 0
    @State private var startTime = Date()

    // Prevents double-advance when timer expires during feedback delay
    @State private var isTransitioning = false

    // Animation states
    @State private var shakeOffset: CGFloat = 0
    @State private var showCorrectGlow = false
    @State private var answerGlowColor = Color.clear

    // Combo system
    @State private var currentStreak = 0

    var currentWord: WordPuzzle? {
        words.indices.contains(currentWordIndex) ? words[currentWordIndex] : nil
    }

    var timeLimit: Int {
        switch level {
        case .easy: return 45
        case .medium: return 30
        case .hard: return 20
        }
    }

    var timerColor: Color {
        let ratio = Double(timeRemaining) / Double(timeLimit)
        if ratio > 0.66 { return .green }
        if ratio > 0.33 { return .yellow }
        return .red
    }

    var comboMultiplier: Double {
        if currentStreak >= 5 { return 2.0 }
        if currentStreak >= 3 { return 1.5 }
        return 1.0
    }

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
                // Top bar
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Level: \(level.rawValue)")
                            .font(.headline)
                            .foregroundColor(.white)

                        Text("Score: \(score)")
                            .font(.subheadline)
                            .foregroundColor(.yellow)

                        // Combo indicator
                        if currentStreak >= 3 {
                            Text("Streak x\(currentStreak) (\(String(format: "%.1f", comboMultiplier))x)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(currentStreak >= 5 ? .yellow : .orange)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 5) {
                        HStack(spacing: 3) {
                            Text("Time:")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("\(timeRemaining)s")
                                .font(.headline)
                                .foregroundColor(timerColor)
                                .fontWeight(.bold)
                                .animation(.easeInOut(duration: 0.5), value: timerColor)
                        }

                        HStack(spacing: 5) {
                            Text("Lives:")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            ForEach(0..<3, id: \.self) { index in
                                if index < lives {
                                    Text("❤️")
                                        .font(.caption)
                                        .transition(.scale.combined(with: .opacity))
                                }
                            }
                        }
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: lives)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.2))

                ScrollView {
                    VStack(spacing: 30) {
                        // Target word display
                        VStack(spacing: 15) {
                            Text("Target Word:")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))

                            HStack(spacing: 10) {
                                ForEach(0..<(currentWord?.word.count ?? 5), id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white, lineWidth: 2)
                                        .frame(width: 40, height: 50)
                                        .overlay(
                                            Text("_")
                                                .font(.title)
                                                .foregroundColor(.white)
                                        )
                                }
                            }
                        }
                        .padding(.top, 30)

                        // Available letters
                        VStack(spacing: 15) {
                            Text("Tap letters to form word")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))

                            FlowLayout(spacing: 10) {
                                ForEach(Array(scrambledLetters.enumerated()), id: \.offset) { index, letter in
                                    LetterTile(
                                        letter: letter,
                                        isUsed: usedIndices.contains(index)
                                    ) {
                                        if !usedIndices.contains(index) {
                                            selectedLetters.append(letter)
                                            usedIndices.insert(index)
                                            triggerHaptic(.light)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        // Your answer display
                        VStack(spacing: 15) {
                            Text("Your Answer:")
                                .font(.headline)
                                .foregroundColor(.white)

                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white.opacity(0.2))
                                    .frame(height: 60)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(answerGlowColor, lineWidth: showCorrectGlow ? 3 : 0)
                                            .animation(.easeInOut(duration: 0.3), value: showCorrectGlow)
                                    )

                                HStack(spacing: 8) {
                                    ForEach(Array(selectedLetters.enumerated()), id: \.offset) { index, letter in
                                        Text(letter)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }

                                    if selectedLetters.isEmpty {
                                        Text("Tap letters above")
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                }
                            }
                            .offset(x: shakeOffset)
                            .padding(.horizontal)
                        }

                        // Feedback message
                        if showFeedback {
                            Text(feedbackMessage)
                                .font(.headline)
                                .foregroundColor(feedbackColor)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(feedbackColor.opacity(0.2))
                                )
                                .transition(.scale.combined(with: .opacity))
                        }

                        // Action buttons
                        HStack(spacing: 20) {
                            Button(action: submitAnswer) {
                                Text("Submit")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(15)
                            }
                            .disabled(selectedLetters.isEmpty)
                            .opacity(selectedLetters.isEmpty ? 0.5 : 1.0)

                            Button(action: clearAnswer) {
                                Text("Clear")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red.opacity(0.7))
                                    .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal)

                        // Hint section (controlled by settings toggle)
                        if hintsEnabled, let word = currentWord {
                            VStack(spacing: 10) {
                                if showHint {
                                    Text("Hint: \(word.hint)")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.black.opacity(0.3))
                                        )
                                        .transition(.opacity)
                                }

                                if !hintUsed {
                                    Button(action: useHint) {
                                        Text("Use Hint (-10 pts)")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .background(Color.orange.opacity(0.7))
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        // Progress indicator
                        VStack(spacing: 10) {
                            Text("Word \(currentWordIndex + 1) of \(words.count)")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))

                            ProgressView(value: Double(currentWordIndex + 1), total: Double(words.count))
                                .tint(.yellow)
                                .padding(.horizontal)
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .onAppear(perform: startGame)
        .onDisappear(perform: stopTimer)
    }

    // MARK: - Haptics

    func triggerHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard hapticsEnabled else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    func triggerNotificationHaptic(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard hapticsEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }

    // MARK: - Animations

    func shakeAnswer() {
        withAnimation(.default.speed(4)) { shakeOffset = 10 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            withAnimation(.default.speed(4)) { shakeOffset = -10 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
            withAnimation(.default.speed(4)) { shakeOffset = 6 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
            withAnimation(.default.speed(4)) { shakeOffset = -6 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
            withAnimation(.default.speed(4)) { shakeOffset = 0 }
        }
    }

    func glowAnswer(color: Color) {
        answerGlowColor = color
        showCorrectGlow = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showCorrectGlow = false
        }
    }

    // MARK: - Game Logic

    func startGame() {
        words = WordDatabase.shared.getWords(for: level)
        currentWordIndex = 0
        score = 0
        lives = 3
        wordsSolved = 0
        totalAttempts = 0
        totalTimeBonus = 0
        currentStreak = 0
        startTime = Date()

        loadNextWord()
        startTimer()
    }

    func loadNextWord() {
        guard let word = currentWord else { return }

        scrambledLetters = word.scrambled()
        selectedLetters = []
        usedIndices = []
        timeRemaining = timeLimit
        hintUsed = false
        showHint = false
        showFeedback = false
        isTransitioning = false
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            guard !isTransitioning else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining == 10 || timeRemaining == 5 {
                    triggerNotificationHaptic(.warning)
                }
            } else {
                handleTimeout()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func submitAnswer() {
        guard let word = currentWord, !isTransitioning else { return }

        let answer = selectedLetters.joined()
        totalAttempts += 1

        if answer == word.word {
            handleCorrectAnswer()
        } else {
            handleWrongAnswer()
        }
    }

    func handleCorrectAnswer() {
        isTransitioning = true
        wordsSolved += 1
        currentStreak += 1

        // Calculate score
        var points = 100

        let timeBonus = timeRemaining * 2
        points += timeBonus
        totalTimeBonus += timeBonus

        if !hintUsed {
            points += 25
        }

        // Apply combo multiplier
        let finalPoints = Int(Double(points) * comboMultiplier)
        score += finalPoints

        let comboText = comboMultiplier > 1.0 ? " (x\(String(format: "%.1f", comboMultiplier)))" : ""
        showFeedbackMessage("✓ Correct! +\(finalPoints) pts\(comboText)", color: .green)

        glowAnswer(color: .green)
        triggerNotificationHaptic(.success)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            moveToNextWord()
        }
    }

    func handleWrongAnswer() {
        currentStreak = 0

        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            lives -= 1
        }
        showFeedbackMessage("✗ Wrong! Try again", color: .red)

        shakeAnswer()
        triggerNotificationHaptic(.error)

        if lives <= 0 {
            endGame()
        } else {
            clearAnswer()
        }
    }

    func handleTimeout() {
        guard !isTransitioning else { return }
        isTransitioning = true
        currentStreak = 0

        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            lives -= 1
        }
        showFeedbackMessage("⏱️ Time's up!", color: .orange)
        triggerNotificationHaptic(.error)

        if lives <= 0 {
            endGame()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                moveToNextWord()
            }
        }
    }

    func moveToNextWord() {
        if currentWordIndex < words.count - 1 {
            currentWordIndex += 1
            loadNextWord()
        } else {
            completeLevel()
        }
    }

    func buildGameResult(didComplete: Bool) -> GameResult {
        let accuracy = totalAttempts > 0 ? Int(Double(wordsSolved) / Double(totalAttempts) * 100) : 0
        let isNewBest = score > gameManager.highScore
        return GameResult(
            score: score,
            timeBonus: totalTimeBonus,
            wordsSolved: wordsSolved,
            totalWords: words.count,
            accuracy: accuracy,
            level: level,
            didComplete: didComplete,
            isNewPersonalBest: isNewBest
        )
    }

    func completeLevel() {
        stopTimer()
        let result = buildGameResult(didComplete: true)
        gameManager.completeLevel(level)
        gameManager.saveScore(score, level: level)
        onGameEnd(result)
    }

    func endGame() {
        stopTimer()
        let result = buildGameResult(didComplete: false)
        gameManager.saveScore(score, level: level)
        onGameEnd(result)
    }

    func clearAnswer() {
        selectedLetters = []
        usedIndices = []
    }

    func useHint() {
        if !hintUsed {
            hintUsed = true
            withAnimation {
                showHint = true
            }
            score = max(0, score - 10)
        }
    }

    func showFeedbackMessage(_ message: String, color: Color) {
        feedbackMessage = message
        feedbackColor = color
        withAnimation {
            showFeedback = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showFeedback = false
            }
        }
    }
}

struct LetterTile: View {
    let letter: String
    let isUsed: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            isPressed = true
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                isPressed = false
            }
        }) {
            Text(letter)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(isUsed ? .gray : .white)
                .frame(width: 60, height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isUsed ? Color.gray.opacity(0.3) : Color.white.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(isUsed ? Color.gray : Color.white, lineWidth: 2)
                        )
                )
                .scaleEffect(isPressed ? 0.85 : 1.0)
                .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isPressed)
        }
        .disabled(isUsed)
    }
}

// Simple flow layout for wrapping letter tiles
struct FlowLayout: Layout {
    var spacing: CGFloat = 10

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

#Preview {
    GamePlayView(
        level: .easy,
        navigateTo: { _ in },
        onGameEnd: { _ in }
    )
}
