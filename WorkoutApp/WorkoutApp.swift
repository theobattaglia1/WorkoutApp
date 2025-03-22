import SwiftUI

@main
struct WorkoutApp: App {
    @StateObject var dataModel = DataModel()
    @StateObject var stopwatchState = StopwatchState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataModel)
                .environmentObject(stopwatchState)
        }
    }
}
