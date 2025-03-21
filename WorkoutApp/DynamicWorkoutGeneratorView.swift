import SwiftUI

struct DynamicWorkoutGeneratorView: View {
    @EnvironmentObject var dataModel: DataModel
    
    // Use a slider for workout length
    @State private var length: Double = 60
    
    // Predefined options
    let availableWorkoutTypes = ["weights", "HIIT", "yoga", "steady-state cardio", "bodyweight", "stretching"]
    let availableBodyParts = ["chest", "arms", "legs", "back", "shoulders", "full body", "abs"]
    let availableGoals = ["fat loss", "muscle mass", "flexibility"]
    
    // Selected options
    @State private var selectedWorkoutTypes: Set<String> = []
    @State private var selectedBodyParts: Set<String> = []
    @State private var selectedGoals: Set<String> = []
    
    @State private var intensity: String = "moderate"
    @State private var experience: String = "moderate"
    
    @State private var generatedWorkout: GeneratedWorkout? = nil
    @State private var showResult: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Workout Length (minutes)").foregroundColor(.primaryText)) {
                    HStack {
                        Slider(value: $length, in: 20...120, step: 5)
                        Text("\(Int(length)) min")
                            .foregroundColor(.primaryText)
                    }
                }
                
                Section(header: Text("Workout Types").foregroundColor(.primaryText)) {
                    ForEach(availableWorkoutTypes, id: \.self) { type in
                        MultipleSelectionRow(title: type, isSelected: selectedWorkoutTypes.contains(type)) {
                            if selectedWorkoutTypes.contains(type) {
                                selectedWorkoutTypes.remove(type)
                            } else {
                                selectedWorkoutTypes.insert(type)
                            }
                        }
                    }
                }
                
                Section(header: Text("Target Body Parts").foregroundColor(.primaryText)) {
                    ForEach(availableBodyParts, id: \.self) { part in
                        MultipleSelectionRow(title: part, isSelected: selectedBodyParts.contains(part)) {
                            if selectedBodyParts.contains(part) {
                                selectedBodyParts.remove(part)
                            } else {
                                selectedBodyParts.insert(part)
                            }
                        }
                    }
                }
                
                Section(header: Text("Goals").foregroundColor(.primaryText)) {
                    ForEach(availableGoals, id: \.self) { goal in
                        MultipleSelectionRow(title: goal, isSelected: selectedGoals.contains(goal)) {
                            if selectedGoals.contains(goal) {
                                selectedGoals.remove(goal)
                            } else {
                                selectedGoals.insert(goal)
                            }
                        }
                    }
                }
                
                Section(header: Text("Intensity").foregroundColor(.primaryText)) {
                    Picker("Intensity", selection: $intensity) {
                        Text("Recovery").tag("recovery")
                        Text("Easy").tag("easy")
                        Text("Moderate").tag("moderate")
                        Text("Hard").tag("hard")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Experience Level").foregroundColor(.primaryText)) {
                    Picker("Experience", selection: $experience) {
                        Text("Novice").tag("novice")
                        Text("Moderate").tag("moderate")
                        Text("Advanced").tag("advanced")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section {
                    Button("Generate Workout") {
                        let constraints = WorkoutConstraints(
                            length: Int(length),
                            workoutTypes: selectedWorkoutTypes.isEmpty ? nil : Array(selectedWorkoutTypes),
                            intensity: intensity,
                            bodyParts: selectedBodyParts.isEmpty ? nil : Array(selectedBodyParts),
                            goals: selectedGoals.isEmpty ? nil : Array(selectedGoals),
                            experience: experience
                        )
                        generatedWorkout = dataModel.generateDynamicWorkout(constraints: constraints)
                        showResult = true
                    }
                    .font(.headline)
                    .foregroundColor(.primaryText)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.secondaryBackground)
                    .cornerRadius(12)
                }
                
                if showResult, let workout = generatedWorkout {
                    Section(header: Text("Generated Workout").foregroundColor(.primaryText)) {
                        Text("Workout ID: \(workout.workoutID)")
                            .foregroundColor(.primaryText)
                        Text("Duration: \(workout.duration)")
                            .foregroundColor(.primaryText)
                        ForEach(workout.exercises) { ex in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(ex.name).bold().foregroundColor(.primaryText)
                                Text("Sets: \(ex.sets), Reps: \(ex.reps), Rest: \(ex.rest)")
                                    .foregroundColor(.primaryText)
                                Text("Equipment: \(ex.equipment)")
                                    .foregroundColor(.primaryText)
                                Text("Instructions: \(ex.instructions)")
                                    .foregroundColor(.secondaryText)
                            }
                            .padding(.vertical, 4)
                            .cardStyle()
                        }
                    }
                }
            }
            .navigationTitle("Workout Generator")
        }
    }
}

struct MultipleSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.primaryText)
                }
            }
        }
        .foregroundColor(.primaryText)
    }
}
