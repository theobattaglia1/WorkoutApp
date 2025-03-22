import SwiftUI

struct GeneratedWorkoutView: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(workout.title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            if let synergy = workout.synergyScore {
                Text("Synergy Score: \(synergy)")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("CardBackground"))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct GeneratedWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        GeneratedWorkoutView(workout: Workout(id: UUID(), title: "Generated Workout", synergyScore: 20))
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.black)
    }
}
