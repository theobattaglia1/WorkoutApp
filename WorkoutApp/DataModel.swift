import Foundation
import SwiftUI

// MARK: - Workout Model

struct Workout: Identifiable, Codable {
    var id: UUID
    var title: String
    var synergyScore: Int?
    // Additional properties can be added as needed (e.g., workout type, exercise list, etc.)
}

// MARK: - DataModel Class

class DataModel: ObservableObject {
    @Published var allWorkouts: [Workout] = []
    
    init() {
        loadWorkouts()
    }
    
    /// Loads local and scheduled workouts and unifies them.
    func loadWorkouts() {
        let localWorkouts = loadLocalWorkouts()
        let scheduledWorkouts = loadScheduledWorkouts()
        // Combine the two sources. You might later filter or separate these as needed.
        allWorkouts = localWorkouts + scheduledWorkouts
        
        // Compute synergy scores for each workout.
        allWorkouts = allWorkouts.map { workout in
            var updatedWorkout = workout
            updatedWorkout.synergyScore = computeSynergyScore(for: workout)
            return updatedWorkout
        }
    }
    
    // MARK: - Local Workouts (JSON)
    
    private func loadLocalWorkouts() -> [Workout] {
        guard let url = Bundle.main.url(forResource: "Workouts", withExtension: "json") else {
            print("Local workouts JSON file not found.")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let workouts = try decoder.decode([Workout].self, from: data)
            return workouts
        } catch {
            print("Error decoding local workouts: \(error)")
            return []
        }
    }
    
    // MARK: - Scheduled Workouts (CSV)
    
    private func loadScheduledWorkouts() -> [Workout] {
        guard let url = Bundle.main.url(forResource: "ScheduledWorkouts", withExtension: "csv") else {
            print("Scheduled workouts CSV file not found.")
            return []
        }
        do {
            let data = try String(contentsOf: url)
            let workouts = parseCSV(data: data)
            return workouts
        } catch {
            print("Error reading scheduled workouts: \(error)")
            return []
        }
    }
    
    /// Simple CSV parser for workouts.
    /// Assumes CSV format with a header row: "title,synergyScore"
    private func parseCSV(data: String) -> [Workout] {
        var workouts: [Workout] = []
        let rows = data.components(separatedBy: "\n")
        guard rows.count > 1 else { return workouts }
        
        // Assume first row is header; process remaining rows.
        for row in rows.dropFirst() where !row.isEmpty {
            let columns = row.components(separatedBy: ",")
            if columns.count >= 2 {
                let title = columns[0]
                let synergyScore = Int(columns[1])
                let workout = Workout(id: UUID(), title: title, synergyScore: synergyScore)
                workouts.append(workout)
            }
        }
        return workouts
    }
    
    // MARK: - Synergy Scoring & Business Logic
    
    /// Placeholder synergy scoring logic.
    /// In production, replace this with your detailed scoring algorithm.
    private func computeSynergyScore(for workout: Workout) -> Int {
        // Example logic: For demonstration, a random score between 15 and 25.
        return Int.random(in: 15...25)
    }
    
    // Future functions for fuzzy matching GIF names and progressive overload logic can be added here.
}
