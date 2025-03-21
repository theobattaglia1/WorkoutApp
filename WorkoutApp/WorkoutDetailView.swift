import SwiftUI

struct WorkoutDetailView: View {
    @EnvironmentObject var dataModel: DataModel
    let workout: Workout

    @State private var showStopwatch = false
    @State private var stopwatchExpanded = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(workout.name)
                        .font(.title)
                        .foregroundColor(.white)

                    Text("Category: \(workout.category ?? "N/A")")
                        .foregroundColor(.white)
                    Text("Equipment: \(workout.equipment ?? "N/A")")
                        .foregroundColor(.white)
                    Text("Duration: \(workout.duration ?? 0) min")
                        .foregroundColor(.white)

                    // Show each exercise
                    ForEach(workout.exercises, id: \.id) { ex in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(ex.name)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Sets: \(ex.sets ?? 0), Reps: \(ex.reps ?? 0)")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }

                    Button {
                        dataModel.logWorkout(workout.name)
                    } label: {
                        Text("Log This Workout")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                    }

                    Button(showStopwatch ? "Hide Stopwatch" : "Show Stopwatch") {
                        showStopwatch.toggle()
                    }
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)

                    // Start universal flow
                    NavigationLink(
                        destination: {
                            let arr = dataModel.transformLocalWorkoutToScheduled(workout)
                            UniversalExerciseFlowView(
                                workoutName: workout.name,
                                exercises: arr,
                                onFinish: {
                                    dataModel.logWorkout(workout.name)
                                }
                            )
                        },
                        label: {
                            Text("START WORKOUT")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                        }
                    )
                }
                .padding()
            }

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
}
