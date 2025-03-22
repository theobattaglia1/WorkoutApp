import SwiftUI

struct ScheduledWorkoutDetailView: View {
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
                
                // Additional details about the workout can be displayed here.
                Spacer()
                
                // Use the unified stopwatch overlay
                StopwatchOverlay()
                    .padding()
                
                Spacer()
            }
        }
        .navigationTitle("Workout Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ScheduledWorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduledWorkoutDetailView(workout: Workout(id: UUID(), title: "Scheduled Workout", synergyScore: 20))
            .environmentObject(StopwatchState())
    }
}
