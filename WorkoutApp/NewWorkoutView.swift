import SwiftUI

struct NewWorkoutView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.dismiss) var dismiss

    @State private var workoutName: String = ""
    @State private var category: String = ""
    @State private var selectedExercises: [Exercise] = []
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Workout Info")) {
                    TextField("Workout Name", text: $workoutName)
                    TextField("Category (optional)", text: $category)
                }
                Section(header: Text("Select Exercises")) {
                    TextField("Search Exercises...", text: $searchText)
                    List(filteredExercises) { ex in
                        MultipleSelectionOptionRow(
                            exercise: ex,
                            isSelected: selectedExercises.contains(where: { $0.id == ex.id })
                        ) {
                            toggleExercise(ex)
                        }
                    }
                }
            }
            .navigationTitle("New Workout")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveWorkout()
                        dismiss()
                    }
                    .disabled(workoutName.isEmpty)
                }
            }
        }
    }

    private var filteredExercises: [Exercise] {
        if searchText.isEmpty {
            return dataModel.allExercises
        } else {
            return dataModel.allExercises.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    private func toggleExercise(_ ex: Exercise) {
        if let idx = selectedExercises.firstIndex(where: { $0.id == ex.id }) {
            selectedExercises.remove(at: idx)
        } else {
            selectedExercises.append(ex)
        }
    }

    private func saveWorkout() {
        dataModel.createUserWorkout(
            name: workoutName,
            category: category.isEmpty ? nil : category,
            exercises: selectedExercises
        )
    }
}

struct MultipleSelectionOptionRow: View {
    let exercise: Exercise
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        HStack {
            Text(exercise.name)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}
