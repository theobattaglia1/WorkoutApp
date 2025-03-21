import Foundation

struct WorkoutConstraints {
    var length: Int?                  // in minutes; default: 60
    var workoutTypes: [String]?         // e.g., ["weights", "HIIT", "yoga"]
    var intensity: String?              // "recovery", "easy", "moderate", "hard"
    var bodyParts: [String]?            // e.g., ["chest", "arms", "full body"]
    var goals: [String]?                // e.g., ["fat loss", "muscle mass", "flexibility"]
    var experience: String?             // "novice", "moderate", "advanced"
}
