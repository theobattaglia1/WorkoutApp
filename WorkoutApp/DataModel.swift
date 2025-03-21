import SwiftUI

// MARK: - Local (JSON) Models
struct Workout: Identifiable, Codable {
    let id: String
    let name: String
    let category: String?
    let equipment: String?
    let duration: Int?
    var exercises: [Exercise]
}

struct Exercise: Identifiable, Codable {
    let id: String
    let name: String
    let gifName: String
    let primaryCategory: String?
    let secondaryCategory: String?
    var sets: Int?
    var reps: Int?
}

// For decoding local Workouts.json
struct WorkoutData: Codable {
    let workouts: [Workout]
}

// MARK: - Scheduled (CSV) Models
struct ScheduledWorkout: Identifiable {
    let id = UUID()
    let date: Date
    let workoutID: String
    let category: String
    var exercises: [ScheduledExercise]
}

// Updated: Include gifName
struct ScheduledExercise: Identifiable {
    let id = UUID()
    let exerciseName: String
    let gifName: String
    var sets: [ScheduledSet]
    let rest: String?
    let instructions: String?
}

struct ScheduledSet: Identifiable, Codable {
    let id = UUID()
    var isCompleted: Bool = false
    var recordedWeight: String = ""
    let reps: String
    let weight: String
}

// MARK: - Workout Log
struct WorkoutLogEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let workoutName: String
    let duration: Int
}

class DataModel: ObservableObject {
    // Local JSON-based workouts
    @Published var allWorkouts: [Workout] = []
    // User-created workouts
    @Published var userWorkouts: [Workout] = []
    // Local exercises from "LocalExercises.json"
    @Published var allExercises: [Exercise] = []
    // Scheduled workouts from CSV
    @Published var scheduledWorkouts: [ScheduledWorkout] = []
    // Workout logs
    @Published var workoutLogs: [WorkoutLogEntry] = []
    // User-provided GIF overrides
    @Published var userGifPaths: [String: String] = [:]

    init() {
        loadLocalWorkouts()
        loadLocalExercises()
        loadUserWorkouts()
        loadLogs()
        loadUserGifPaths()
        Task { await loadScheduledWorkoutsCSV() }
    }

    // MARK: - Local JSON Loading
    private func loadLocalWorkouts() {
        guard let url = Bundle.main.url(forResource: "Workouts", withExtension: "json") else {
            print("Workouts.json not found.")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(WorkoutData.self, from: data)
            self.allWorkouts = decoded.workouts
            print("Loaded \(allWorkouts.count) local workouts from Workouts.json.")
        } catch {
            print("Error decoding Workouts.json: \(error)")
        }
    }

    private func loadLocalExercises() {
        guard let url = Bundle.main.url(forResource: "LocalExercises", withExtension: "json") else {
            print("LocalExercises.json not found.")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([Exercise].self, from: data)
            self.allExercises = decoded
            print("Loaded \(decoded.count) exercises from LocalExercises.json.")
        } catch {
            print("Error decoding LocalExercises.json: \(error)")
        }
    }

    // MARK: - User Workouts
    func loadUserWorkouts() {
        guard let data = UserDefaults.standard.data(forKey: "UserWorkouts") else { return }
        do {
            let decoded = try JSONDecoder().decode([Workout].self, from: data)
            self.userWorkouts = decoded
        } catch {
            print("Error decoding userWorkouts: \(error)")
        }
    }

    func saveUserWorkouts() {
        do {
            let data = try JSONEncoder().encode(userWorkouts)
            UserDefaults.standard.set(data, forKey: "UserWorkouts")
        } catch {
            print("Error encoding userWorkouts: \(error)")
        }
    }

    func createUserWorkout(name: String, category: String?, exercises: [Exercise]) {
        let newID = UUID().uuidString
        let newWorkout = Workout(
            id: newID,
            name: name,
            category: category,
            equipment: nil,
            duration: nil,
            exercises: exercises
        )
        userWorkouts.append(newWorkout)
        saveUserWorkouts()
    }

    // MARK: - Logs
    func saveLogs() {
        do {
            let encoded = try JSONEncoder().encode(workoutLogs)
            UserDefaults.standard.set(encoded, forKey: "WorkoutLogs")
        } catch {
            print("Error encoding logs: \(error)")
        }
    }

    private func loadLogs() {
        guard let data = UserDefaults.standard.data(forKey: "WorkoutLogs") else { return }
        do {
            let decoded = try JSONDecoder().decode([WorkoutLogEntry].self, from: data)
            workoutLogs = decoded
        } catch {
            print("Error decoding logs: \(error)")
        }
    }

    func logWorkout(_ workoutName: String) {
        let entry = WorkoutLogEntry(date: Date(), workoutName: workoutName, duration: 0)
        workoutLogs.append(entry)
        saveLogs()
    }

    // MARK: - CSV-based Scheduled Workouts
    @MainActor
    func loadScheduledWorkoutsCSV() async {
        guard let csvURL = Bundle.main.url(forResource: "ScheduledWorkouts", withExtension: "csv") else {
            print("ScheduledWorkouts.csv not found.")
            return
        }
        do {
            let data = try Data(contentsOf: csvURL)
            if let csvString = String(data: data, encoding: .utf8) {
                let lines = csvString.components(separatedBy: .newlines)
                guard lines.count > 1 else { return }
                let dataLines = lines.dropFirst()
                var temp: [ScheduledWorkout] = []
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                for line in dataLines {
                    let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmed.isEmpty { continue }
                    let cols = parseCSVLine(trimmed)
                    if cols.count < 16 { continue }
                    let dateStr  = cols[0]
                    let wID      = cols[1]
                    let exName   = cols[2]
                    let set1r    = cols[3]
                    let set1w    = cols[4]
                    let set2r    = cols[5]
                    let set2w    = cols[6]
                    let set3r    = cols[7]
                    let set3w    = cols[8]
                    let set4r    = cols[9]
                    let set4w    = cols[10]
                    let set5r    = cols[11]
                    let set5w    = cols[12]
                    let restVal  = cols[13]
                    let instrVal = cols[14]
                    let catVal   = cols[15]
                    guard let dateObj = dateFormatter.date(from: dateStr) else { continue }
                    let rawSets = [
                        (set1r, set1w),
                        (set2r, set2w),
                        (set3r, set3w),
                        (set4r, set4w),
                        (set5r, set5w)
                    ]
                    var ssets: [ScheduledSet] = []
                    for (rr, ww) in rawSets {
                        if rr.isEmpty || rr == "N/A" { continue }
                        ssets.append(ScheduledSet(reps: rr, weight: ww))
                    }
                    // Use fuzzy matching to guess a gif if needed
                    let bestGif = findClosestGifName(for: exName)
                    let exObj = ScheduledExercise(
                        exerciseName: exName,
                        gifName: bestGif,
                        sets: ssets,
                        rest: (restVal.isEmpty || restVal == "N/A") ? nil : restVal,
                        instructions: (instrVal.isEmpty || instrVal == "N/A") ? nil : instrVal
                    )
                    if let idx = temp.firstIndex(where: { $0.date == dateObj && $0.workoutID == wID }) {
                        temp[idx].exercises.append(exObj)
                    } else {
                        let sw = ScheduledWorkout(
                            date: dateObj,
                            workoutID: wID,
                            category: catVal.isEmpty ? "UNKNOWN" : catVal,
                            exercises: [exObj]
                        )
                        temp.append(sw)
                    }
                }
                temp.sort { $0.date < $1.date }
                scheduledWorkouts = temp
                print("Loaded \(temp.count) scheduled workouts from CSV.")
            }
        } catch {
            print("Error reading ScheduledWorkouts.csv: \(error)")
        }
    }

    private func parseCSVLine(_ line: String) -> [String] {
        var results: [String] = []
        var current = ""
        var inQuotes = false
        for char in line {
            if char == "\"" {
                inQuotes.toggle()
                continue
            }
            if char == "," && !inQuotes {
                results.append(current)
                current = ""
            } else {
                current.append(char)
            }
        }
        if !current.isEmpty { results.append(current) }
        return results
    }

    // MARK: - User GIF Overrides
    func loadUserGifPaths() {
        if let dict = UserDefaults.standard.dictionary(forKey: "UserGifPaths") as? [String: String] {
            userGifPaths = dict
        }
    }

    func saveUserGifPaths() {
        UserDefaults.standard.set(userGifPaths, forKey: "UserGifPaths")
    }

    func gifPath(for key: String) -> String? {
        userGifPaths[key]
    }

    func setGifPath(for key: String, path: String) {
        userGifPaths[key] = path
        saveUserGifPaths()
    }

    // MARK: - Transform Local Workout → [ScheduledExercise]
    func transformLocalWorkoutToScheduled(_ workout: Workout) -> [ScheduledExercise] {
        workout.exercises.map { ex in
            let numberOfSets = ex.sets ?? 1
            let repsString = ex.reps.map { String($0) } ?? "?"
            var ssets: [ScheduledSet] = []
            for _ in 0..<numberOfSets {
                ssets.append(ScheduledSet(reps: repsString, weight: "??"))
            }
            // Use the original gifName if available; otherwise, try fuzzy matching.
            let finalGif = ex.gifName.isEmpty ? findClosestGifName(for: ex.name) : ex.gifName
            return ScheduledExercise(
                exerciseName: ex.name,
                gifName: finalGif,
                sets: ssets,
                rest: nil,
                instructions: nil
            )
        }
    }

    // MARK: - Fuzzy Matching for GIF Names
    func findClosestGifName(for exerciseName: String) -> String {
        let cleanedInput = cleaned(exerciseName)
        var bestGif: String?
        var bestDistance = Int.max
        for localEx in allExercises {
            let cleanedLocal = cleaned(localEx.name)
            let dist = levenshteinDistance(cleanedInput, cleanedLocal)
            if dist < bestDistance {
                bestDistance = dist
                bestGif = localEx.gifName
            }
        }
        if let final = bestGif, !final.isEmpty {
            return final
        }
        let guess = cleanedInput + ".gif"
        print("No close match found for \"\(exerciseName)\", guessing \"\(guess)\"")
        return guess
    }

    private func cleaned(_ s: String) -> String {
        s.lowercased().components(separatedBy: .punctuationCharacters).joined().replacingOccurrences(of: " ", with: "")
    }

    private func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
        let a = Array(s1), b = Array(s2)
        let m = a.count, n = b.count
        var dp = [[Int]](repeating: [Int](repeating: 0, count: n+1), count: m+1)
        for i in 1...m { dp[i][0] = i }
        for j in 1...n { dp[0][j] = j }
        for i in 1...m {
            for j in 1...n {
                if a[i-1] == b[j-1] {
                    dp[i][j] = dp[i-1][j-1]
                } else {
                    dp[i][j] = 1 + min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])
                }
            }
        }
        return dp[m][n]
    }

    // MARK: - Dynamic Workout Generator
    func generateDynamicWorkout(constraints: WorkoutConstraints) -> GeneratedWorkout {
        // Defaults
        let length = constraints.length ?? 60
        let types = constraints.workoutTypes ?? ["weights"]
        let intensity = constraints.intensity?.lowercased() ?? "moderate"
        let parts = constraints.bodyParts?.map { $0.lowercased() } ?? ["full body"]
        let goals = constraints.goals ?? ["balanced"]
        let experience = constraints.experience?.lowercased() ?? "moderate"
        
        // Filter candidates from allExercises using a simple match on body parts:
        let candidates = allExercises.filter { exercise in
            let name = exercise.name.lowercased()
            if parts.contains("full body") { return true }
            for part in parts {
                if name.contains(part) { return true }
            }
            return false
        }
        
        // Select up to 6 exercises while checking synergy.
        var selected: [Exercise] = []
        for candidate in candidates {
            var acceptable = true
            for sel in selected {
                let score = calculatePairwiseSynergyScore(sel, candidate)
                if score > 20 { // threshold for redundancy
                    acceptable = false
                    break
                }
            }
            if acceptable {
                selected.append(candidate)
            }
            if selected.count >= 6 { break }
        }
        if selected.isEmpty {
            selected = Array(candidates.prefix(6))
        }
        
        // Map intensity to training variables:
        var sets: Int = 3
        var reps: String = "8-12"
        switch intensity {
        case "hard":
            sets = 4; reps = "6-8"
        case "easy":
            sets = 3; reps = "12-15"
        case "recovery":
            sets = 2; reps = "15-20"
        default:
            sets = 3; reps = "8-12"
        }
        
        // Adjust rest based on experience:
        var baseRest = 60
        switch experience {
        case "novice":
            baseRest += 15  // 75s
        case "advanced":
            baseRest -= 15  // 45s
        default:
            break
        }
        let restString = "\(baseRest)s"
        
        // Build GeneratedExercises from selected exercises.
        var genExercises: [GeneratedExercise] = []
        for exercise in selected {
            let equip = exercise.primaryCategory ?? "Bodyweight"  // Use primaryCategory as a placeholder
            let instruction = "Perform \(exercise.name) with proper form targeting \(equip)."
            let genEx = GeneratedExercise(name: exercise.name, sets: sets, reps: reps, rest: restString, equipment: equip, instructions: instruction)
            genExercises.append(genEx)
        }
        
        let generatedWorkout = GeneratedWorkout(date: Date(), workoutID: UUID().uuidString, duration: "\(length) minutes", exercises: genExercises)
        return generatedWorkout
    }
    
    // A simple synergy scoring between two exercises using their names.
    func calculatePairwiseSynergyScore(_ exA: Exercise, _ exB: Exercise) -> Int {
        var score = 0
        let nameA = exA.name.lowercased()
        let nameB = exB.name.lowercased()
        if nameA.contains("chest") && nameB.contains("chest") {
            score += 10
        }
        if nameA.contains("squat") && nameB.contains("squat") {
            score += 8
        }
        if nameA.contains("press") && nameB.contains("press") {
            score += 8
        }
        if let secA = exA.secondaryCategory?.lowercased(), let secB = exB.secondaryCategory?.lowercased(), secA == secB {
            score += 5
        }
        return score
    }
}
