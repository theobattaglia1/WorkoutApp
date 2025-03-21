import SwiftUI

struct ScheduledWorkoutDetailView: View {
    @EnvironmentObject var dataModel: DataModel
    @EnvironmentObject var stopwatch: StopwatchState

    let workout: ScheduledWorkout

    @State private var showStopwatch = false
    @State private var stopwatchExpanded = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                Text("Scheduled Workout: \(workout.workoutID)")
                    .font(.title2)
                    .foregroundColor(.white)

                // You can format the date
                Text("Date: \(formattedDate(workout.date))")
                    .foregroundColor(.white)
                Text("Category: \(workout.category)")
                    .foregroundColor(.white)

                Text("Exercises in this workout:")
                    .foregroundColor(.white)

                List {
                    ForEach(workout.exercises) { ex in
                        Text(ex.exerciseName)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.gray.opacity(0.2))
                }
                .frame(height: 200)
                .scrollContentBackground(.hidden)
                .background(Color.black)

                HStack {
                    Button {
                        showStopwatch.toggle()
                    } label: {
                        Text(showStopwatch ? "Hide Stopwatch" : "Show Stopwatch")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                    }

                    Button {
                        dataModel.logWorkout("Scheduled \(workout.workoutID)")
                    } label: {
                        Text("Log Workout")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                }

                NavigationLink(
                    destination: UniversalExerciseFlowView(
                        workoutName: "Scheduled \(workout.workoutID)",
                        exercises: workout.exercises,
                        onFinish: {
                            dataModel.logWorkout("Scheduled \(workout.workoutID)")
                        }
                    )
                ) {
                    Text("START WORKOUT")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                }

                Spacer()
            }
            .padding()

            if showStopwatch {
                HStack {
                    if stopwatchExpanded {
                        ExpandedStopwatchView(showStopwatch: $showStopwatch, isExpanded: $stopwatchExpanded)
                            .frame(height: 120)
                    } else {
                        CollapsedStopwatchView(showStopwatch: $showStopwatch, isExpanded: $stopwatchExpanded)
                            .frame(height: 40)
                    }
                }
                .padding(.top, 50)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    func formattedDate(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df.string(from: date)
    }
}
