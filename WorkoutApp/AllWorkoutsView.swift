import SwiftUI

struct AllWorkoutsView: View {
    @EnvironmentObject var dataModel: DataModel

    @State private var showNewWorkout = false
    @State private var showWorkoutGenerator = false
    @State private var selectedCategory: String = "ALL"

    let categories = ["ALL", "CHEST", "BACK", "ARMS", "SHOULDERS", "LOWER", "FULL", "UNKNOWN"]

    var body: some View {
        ZStack {
            Color.primaryBackground.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    Text("ALL WORKOUTS")
                        .font(.largeTitle).bold()
                        .foregroundColor(.primaryText)
                        .padding(.top, 20)

                    // Category Picker
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat)
                                .foregroundColor(.primaryText)
                                .tag(cat)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // Generate New Workout Button
                    Button {
                        showWorkoutGenerator = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Generate New Workout")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.primaryText)
                        .padding()
                        .background(Color.borderGray)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                    }

                    // Display Workouts
                    ForEach(mergedLocalUser, id: \.id) { workout in
                        NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(workout.name)
                                    .font(.headline)
                                    .foregroundColor(.primaryText)
                                Text(workout.category ?? "N/A")
                                    .font(.subheadline)
                                    .foregroundColor(.secondaryText)
                            }
                            .cardStyle()
                            .padding(.horizontal)
                        }
                    }

                    Spacer().frame(height: 40)
                }
            }
        }
        // Show the new generator as a sheet
        .sheet(isPresented: $showWorkoutGenerator) {
            DynamicWorkoutGeneratorView()
                .environmentObject(dataModel)
        }
        .sheet(isPresented: $showNewWorkout) {
            NewWorkoutView()
                .environmentObject(dataModel)
        }
    }

    var mergedLocalUser: [Workout] {
        let filteredLocal = dataModel.allWorkouts.filter { matchCat($0.category) }
        let filteredUser  = dataModel.userWorkouts.filter { matchCat($0.category) }
        return (filteredLocal + filteredUser).sorted { $0.name < $1.name }
    }

    private func matchCat(_ cat: String?) -> Bool {
        if selectedCategory == "ALL" { return true }
        return (cat ?? "UNKNOWN").uppercased() == selectedCategory.uppercased()
    }
}
