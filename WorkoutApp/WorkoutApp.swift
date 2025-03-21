import SwiftUI

@main
struct WorkoutApp: App {
    @StateObject private var dataModel = DataModel()
    @StateObject private var stopwatch = StopwatchState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataModel)
                .environmentObject(stopwatch)
        }
    }
}
