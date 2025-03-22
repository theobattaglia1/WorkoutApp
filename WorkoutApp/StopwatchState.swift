import Foundation
import SwiftUI

class StopwatchState: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0
    @Published var isRunning: Bool = false
    @Published var isExpanded: Bool = false
    
    private var timer: Timer?
    
    func start() {
        guard !isRunning else { return }
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsedTime += 1
        }
    }
    
    func stop() {
        guard isRunning else { return }
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func reset() {
        stop()
        elapsedTime = 0
    }
    
    deinit {
        timer?.invalidate()
    }
}
