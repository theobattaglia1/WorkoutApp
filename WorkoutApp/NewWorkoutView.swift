import SwiftUI

struct NewWorkoutView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var searchText: String = ""
    @State private var selectedExercises: [Exercise] = []
    
    // Dummy list of exercises.
    let dummyExercises: [Exercise] = [
        Exercise(title: "Push Ups", details: "3 sets x 12 reps"),
        Exercise(title: "Squats", details: "3 sets x 15 reps"),
        Exercise(title: "Plank", details: "3 sets x 60 sec")
    ]
    
    // Filter the dummy exercises based on the search text.
    var filteredExercises: [Exercise] {
        if searchText.isEmpty {
            return dummyExercises
        } else {
            return dummyExercises.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("New Workout")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                // Search field
                TextField("Search exercises", text: $searchText)
                    .padding()
                    .background(Color("CardBackground"))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                
                // List of exercises that match the search criteria.
                List(filteredExercises) { exercise in
                    Button(action: {
                        toggleExerciseSelection(exercise)
                    }) {
                        HStack {
                            Text(exercise.title)
                                .foregroundColor(.white)
                            Spacer()
                            if selectedExercises.contains(where: { $0.id == exercise.id }) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding()
                        .background(Color("CardBackground"))
                        .cornerRadius(8)
                    }
                    .listRowBackground(Color.black)
                }
                .listStyle(PlainListStyle())
                
                // Button to create a new workout from selected exercises.
                Button(action: createWorkout) {
                    Text("Create Workout")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                Spacer()
            }
        }
        .navigationTitle("New Workout")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Toggle selection state of an exercise.
    private func toggleExerciseSelection(_ exercise: Exercise) {
        if let index = selectedExercises.firstIndex(where: { $0.id == exercise.id }) {
            selectedExercises.remove(at: index)
        } else {
            selectedExercises.append(exercise)
        }
    }
    
    // Create a new workout using the selected exercises and append it to dataModel.allWorkouts.
    private func createWorkout() {
        let title = selectedExercises.map { $0.title }.joined(separator: ", ")
        let newWorkout = Workout(id: UUID(), title: title.isEmpty ? "Custom Workout" : title, synergyScore: nil)
        dataModel.allWorkouts.append(newWorkout)
    }
}

struct NewWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewWorkoutView()
                .environmentObject(DataModel())
        }
    }
}
