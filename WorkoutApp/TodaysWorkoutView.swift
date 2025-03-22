import SwiftUI

struct TodayWorkoutView: View {
    @EnvironmentObject var dataModel: DataModel

    // For demonstration, assuming the first workout is today's workout.
    // Replace this with actual logic to determine today's workout.
    var todaysWorkout: Workout? {
        return dataModel.allWorkouts.first
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if let workout = todaysWorkout {
                VStack(spacing: 20) {
                    Text("Today's Workout")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    WorkoutDetailView(workout: workout)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                }
            } else {
                Text("No workout scheduled for today")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Today's Workout")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TodayWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        let dataModel = DataModel()
        dataModel.allWorkouts = [
            Workout(id: UUID(), title: "Today's Full Body", synergyScore: 20)
        ]
        return NavigationStack {
            TodayWorkoutView().environmentObject(dataModel)
        }
    }
}
