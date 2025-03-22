import SwiftUI

struct DynamicWorkoutGeneratorView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var workoutLength: Double = 30
    @State private var selectedBodyParts: Set<String> = []
    @State private var intensity: Double = 5
    @State private var experience: Int = 2
    @State private var goal: String = ""
    @State private var generatedWorkout: Workout? = nil

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    Text("Generate New Workout")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    // ... other input sections ...

                    // Generate Button
                    Button(action: generateWorkout) {
                        Text("Generate Workout")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 4)
                    }
                    .padding(.vertical, 20)
                    
                    if let workout = generatedWorkout {
                        // Use the global GeneratedWorkoutView from GeneratedWorkout.swift
                        GeneratedWorkoutView(workout: workout)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Workout Generator")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func generateWorkout() {
        // Your workout generation logic
        let newWorkout = Workout(id: UUID(), title: "Custom Workout - \(Int(workoutLength)) min", synergyScore: Int(intensity * 2))
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            generatedWorkout = newWorkout
        }
    }
}
