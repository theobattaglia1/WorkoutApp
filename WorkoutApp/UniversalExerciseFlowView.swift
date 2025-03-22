import SwiftUI

struct UniversalExerciseFlowView: View {
    @EnvironmentObject var stopwatchState: StopwatchState
    @State private var currentIndex: Int = 0
    let exercises: [Exercise] // Array of exercises provided to the view
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Synergy Alert Banner
                if let alertText = synergyAlertText() {
                    Text(alertText)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(8)
                        .transition(.opacity)
                }
                
                Spacer()
                
                // Main Exercise Card
                ExerciseCardView(exercise: exercises[currentIndex])
                
                Spacer()
                
                // Navigation Buttons
                HStack(spacing: 40) {
                    Button(action: previousExercise) {
                        Image(systemName: "chevron.left")
                            .frame(width: 60, height: 60)
                    }
                    .buttonStyle(FlowButtonStyle())
                    
                    Button(action: nextExercise) {
                        Image(systemName: "chevron.right")
                            .frame(width: 60, height: 60)
                    }
                    .buttonStyle(FlowButtonStyle())
                }
                .padding(.bottom, 16)
                
                // Progressive Overload Suggestion Banner
                if let suggestion = overloadSuggestion() {
                    Text(suggestion)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color("CardBackground"))
                        .cornerRadius(8)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.horizontal, 20)
            
            // Stopwatch Overlay positioned in the top-right corner
            VStack {
                HStack {
                    Spacer()
                    StopwatchOverlay()
                        .padding(20)
                }
                Spacer()
            }
        }
        .animation(.easeInOut, value: currentIndex)
    }
    
    // MARK: - Placeholder Logic for Alerts & Suggestions
    
    private func synergyAlertText() -> String? {
        // Replace with actual synergy logic; placeholder:
        if exercises[currentIndex].requiresSynergyAlert {
            return "Synergy Alert: Adjust exercise selection."
        }
        return nil
    }
    
    private func overloadSuggestion() -> String? {
        // Replace with actual progressive overload logic; placeholder:
        if exercises[currentIndex].suggestOverload {
            return "Progressive Overload Suggestion: Increase weight by 5%."
        }
        return nil
    }
    
    // MARK: - Navigation Actions
    
    private func previousExercise() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
    
    private func nextExercise() {
        if currentIndex < exercises.count - 1 {
            currentIndex += 1
        }
    }
}

// MARK: - Exercise Card View

struct ExerciseCardView: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(spacing: 12) {
            Text(exercise.title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(exercise.details)
                .font(.system(size: 18))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            // Placeholder for set/reps input (expand as needed)
            HStack(spacing: 16) {
                Button("Set") { }
                    .buttonStyle(SecondaryButtonStyle())
                Button("Reps") { }
                    .buttonStyle(SecondaryButtonStyle())
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color("CardBackground"))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Custom Button Styles

struct FlowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .background(Color("CardBackground"))
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: configuration.isPressed)
            .frame(width: 60, height: 60)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .padding()
            .background(Color.gray.opacity(0.3))
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Dummy Data Model

struct Exercise: Identifiable {
    let id: UUID = UUID()
    let title: String
    let details: String
    var requiresSynergyAlert: Bool = false
    var suggestOverload: Bool = false
}

// MARK: - Preview

struct UniversalExerciseFlowView_Previews: PreviewProvider {
    static let sampleExercises: [Exercise] = [
        Exercise(title: "Push Ups", details: "3 sets x 12 reps", requiresSynergyAlert: true),
        Exercise(title: "Squats", details: "3 sets x 15 reps", suggestOverload: true),
        Exercise(title: "Plank", details: "3 sets x 60 sec")
    ]
    
    static var previews: some View {
        UniversalExerciseFlowView(exercises: sampleExercises)
            .environmentObject(StopwatchState())
    }
}
