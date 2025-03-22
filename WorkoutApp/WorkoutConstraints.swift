import Foundation

struct WorkoutConstraints {
    var workoutLengthMinutes: Int
    var targetBodyParts: [String]
    var intensity: Int
    var experienceLevel: Int
    var goal: String
    
    // Computes a recommended rest interval (in seconds) based on intensity.
    // For example, higher intensity might result in shorter rest intervals.
    var recommendedRestInterval: TimeInterval {
        // Ensure a minimum of 60 seconds, reducing rest by 10 sec per intensity point.
        return TimeInterval(max(60, 120 - (intensity * 10)))
    }
    
    // A default set of constraints for quick workout generation.
    static var defaultConstraints: WorkoutConstraints {
        return WorkoutConstraints(
            workoutLengthMinutes: 30,
            targetBodyParts: [],
            intensity: 5,
            experienceLevel: 3,
            goal: "General"
        )
    }
}
