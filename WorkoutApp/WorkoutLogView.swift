import SwiftUI

struct WorkoutLogView: View {
    @EnvironmentObject var dataModel: DataModel

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if dataModel.allWorkouts.isEmpty {
                Text("No logs available")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(dataModel.allWorkouts) { workout in
                            LogCardView(workout: workout)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .navigationTitle("Workout Log")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LogCardView: View {
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
            // Additional log details or performance metrics can be added here.
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("CardBackground"))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct WorkoutLogView_Previews: PreviewProvider {
    static var previews: some View {
        let dataModel = DataModel()
        dataModel.allWorkouts = [
            Workout(id: UUID(), title: "Full Body Blast", synergyScore: 22),
            Workout(id: UUID(), title: "Cardio & Core", synergyScore: 18)
        ]
        return NavigationStack {
            WorkoutLogView().environmentObject(dataModel)
        }
    }
}
