import SwiftUI

struct WorkoutLogView: View {
    @EnvironmentObject var dataModel: DataModel

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("WORKOUT LOG")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()

                List(dataModel.workoutLogs.sorted { $0.date > $1.date }) { log in
                    VStack(alignment: .leading) {
                        Text(log.workoutName)
                            .foregroundColor(.white)
                            .font(.headline)
                        Text("Date: \(formattedDate(log.date))  Duration: \(log.duration) min")
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }
                    .listRowBackground(Color.gray.opacity(0.2))
                }
                .scrollContentBackground(.hidden)
                .background(Color.black)
            }
        }
        .navigationTitle("Workout Log")
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
