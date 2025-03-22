import SwiftUI

// For demonstration purposes, we reuse the Exercise model from UniversalExerciseFlowView.
struct AllExercisesView: View {
    // Dummy list of exercises
    let exercises: [Exercise] = [
        Exercise(title: "Push Ups", details: "3 sets x 12 reps"),
        Exercise(title: "Squats", details: "3 sets x 15 reps"),
        Exercise(title: "Plank", details: "3 sets x 60 sec")
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(exercises) { exercise in
                        SimpleExerciseCardView(exercise: exercise)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle("All Exercises")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SimpleExerciseCardView: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(exercise.title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            Text(exercise.details)
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("CardBackground"))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct AllExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AllExercisesView()
        }
    }
}
