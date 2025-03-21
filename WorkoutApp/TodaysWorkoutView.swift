import SwiftUI

struct TodaysWorkoutView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var selectedDate = Date()

    var workoutsForDate: [ScheduledWorkout] {
        dataModel.scheduledWorkouts.filter {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("TODAY'S WORKOUT")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()

                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .colorInvert()
                    .colorMultiply(.white)
                    .padding()

                if workoutsForDate.isEmpty {
                    Text("No scheduled workouts for this date.")
                        .foregroundColor(.white)
                        .padding()
                } else {
                    List(workoutsForDate) { w in
                        NavigationLink(destination: ScheduledWorkoutDetailView(workout: w)) {
                            Text("Workout ID: \(w.workoutID) — \(w.exercises.count) exercises")
                                .foregroundColor(.white)
                        }
                        .listRowBackground(Color.gray.opacity(0.2))
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.black)
                }
            }
        }
        .navigationTitle("Today's Workout")
    }
}
