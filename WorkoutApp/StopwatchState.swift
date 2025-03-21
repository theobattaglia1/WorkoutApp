import SwiftUI

class StopwatchState: ObservableObject {
    @Published var isRunning = false
    @Published var startTime: Date?
    @Published var elapsedTime: TimeInterval = 0
    var timer: Timer?

    func start() {
        isRunning = true
        if startTime == nil {
            startTime = Date()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let start = self.startTime {
                self.elapsedTime = Date().timeIntervalSince(start)
            }
        }
    }

    func stop() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    func reset() {
        stop()
        elapsedTime = 0
        startTime = nil
    }

    func formatTime() -> String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        let fraction = Int((elapsedTime - floor(elapsedTime)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, fraction)
    }
}
