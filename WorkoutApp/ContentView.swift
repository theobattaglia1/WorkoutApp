import SwiftUI

struct ContentView: View {
    @Namespace private var animation

    enum NavigationCard: String, CaseIterable, Identifiable {
        var id: String { rawValue }
        case allWorkouts = "All Workouts"
        case todaysWorkout = "Today's Workout"
        case allExercises = "All Exercises"
        case workoutLog = "Workout Log"
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 32),
        GridItem(.flexible(), spacing: 32)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    Text("Workout App")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 60)
                    
                    Spacer()
                    
                    LazyVGrid(columns: columns, spacing: 32) {
                        ForEach(NavigationCard.allCases) { card in
                            NavigationLink(value: card) {
                                CardView(card: card, animation: animation)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .navigationDestination(for: NavigationCard.self) { card in
                destinationView(for: card)
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for card: NavigationCard) -> some View {
        switch card {
        case .allWorkouts:
            AllWorkoutsView()
        case .todaysWorkout:
            TodayWorkoutView()
        case .allExercises:
            AllExercisesView()
        case .workoutLog:
            WorkoutLogView()
        }
    }
}

struct CardView: View {
    let card: ContentView.NavigationCard
    var animation: Namespace.ID
    
    var body: some View {
        VStack(spacing: 8) {
            // Optional minimalist icon using SF Symbols
            Image(systemName: iconName(for: card))
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
            Text(card.rawValue)
                .font(.system(size: 20))
                .foregroundColor(.white)
        }
        .frame(width: 150, height: 150)
        .background(
            // Subtle gradient for depth
            LinearGradient(
                gradient: Gradient(colors: [Color("CardGradientStart"), Color("CardGradientEnd")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .matchedGeometryEffect(id: card.rawValue, in: animation)
        .scaleEffect(1.0)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: 1.0)
    }
    
    private func iconName(for card: ContentView.NavigationCard) -> String {
        switch card {
        case .allWorkouts:
            return "list.bullet.rectangle"
        case .todaysWorkout:
            return "calendar"
        case .allExercises:
            return "figure.walk"
        case .workoutLog:
            return "doc.text"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
