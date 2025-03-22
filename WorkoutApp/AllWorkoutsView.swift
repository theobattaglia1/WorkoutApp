import SwiftUI

struct AllWorkoutsView: View {
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    if dataModel.allWorkouts.isEmpty {
                        Text("No workouts available")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                    } else {
                        ForEach(dataModel.allWorkouts) { workout in
                            NavigationLink {
                                // Reference the global WorkoutDetailView (defined in WorkoutDetailView.swift)
                                WorkoutDetailView(workout: workout)
                            } label: {
                                WorkoutCardView(workout: workout)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle("All Workouts")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Your WorkoutCardView remains as defined:
struct WorkoutCardView: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(workout.title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            if let synergy = workout.synergyScore {
                Text("Synergy Score: \(synergy)")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("CardBackground"))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
