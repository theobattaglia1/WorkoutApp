import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer().frame(height: 60) // extra top padding

                    Text("Workout App")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)

                    // 1) ALL WORKOUTS
                    NavigationLink(destination: AllWorkoutsView()) {
                        homeButtonLabel("ALL WORKOUTS")
                    }

                    // 2) TODAY’S WORKOUT
                    NavigationLink(destination: TodaysWorkoutView()) {
                        homeButtonLabel("TODAY’S WORKOUT")
                    }

                    // 3) ALL EXERCISES
                    NavigationLink(destination: AllExercisesView()) {
                        homeButtonLabel("ALL EXERCISES")
                    }

                    // 4) WORKOUT LOG
                    NavigationLink(destination: WorkoutLogView()) {
                        homeButtonLabel("WORKOUT LOG")
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .navigationBarHidden(true)
        }
    }

    // Helper for uniform button styling
    private func homeButtonLabel(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.white.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
