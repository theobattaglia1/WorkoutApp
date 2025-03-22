import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout
    @EnvironmentObject var stopwatchState: StopwatchState

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                Text(workout.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                if let synergy = workout.synergyScore {
                    Text("Synergy Score: \(synergy)")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                }
                
                // Additional workout details can be inserted here.
                Spacer()
                
                // Stopwatch overlay for timing or progressive overload cues.
                StopwatchOverlay()
                    .padding()
                
                Spacer()
            }
        }
        .navigationTitle("Workout Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailView(workout: Workout(id: UUID(), title: "Sample Workout", synergyScore: 20))
            .environmentObject(StopwatchState())
    }
}
