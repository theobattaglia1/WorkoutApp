import Foundation

struct GeneratedExercise: Codable, Identifiable {
    let id = UUID()
    var name: String
    var sets: Int
    var reps: String
    var rest: String
    var equipment: String
    var instructions: String
}

struct GeneratedWorkout: Codable {
    var date: Date
    var workoutID: String
    var duration: String      // e.g., "60 minutes"
    var exercises: [GeneratedExercise]
}
