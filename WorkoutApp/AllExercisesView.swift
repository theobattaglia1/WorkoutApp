import SwiftUI
import SDWebImageSwiftUI

struct AllExercisesView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var searchText = ""
    @State private var selectedCategory: String = "ALL"

    let categories = ["ALL", "CHEST", "BACK", "LEGS", "ARMS", "SHOULDERS", "FULL", "ABS", "UNKNOWN"]

    var filteredExercises: [Exercise] {
        dataModel.allExercises.filter { ex in
            // matches search
            let matchesSearch = searchText.isEmpty
                || ex.name.lowercased().contains(searchText.lowercased())

            // This example just does a naive "primaryCategory" or "secondaryCategory" check if you had them
            // Or we do a name-based filter
            let catUp = selectedCategory.uppercased()
            let nameUp = ex.name.uppercased()

            let matchesCategory = (selectedCategory == "ALL") || nameUp.contains(catUp)
            return matchesSearch && matchesCategory
        }
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("ALL EXERCISES")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()

                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { cat in
                        Text(cat).tag(cat)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .foregroundColor(.white)

                HStack {
                    TextField("Search Exercises", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }

                List(filteredExercises) { exercise in
                    NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                        Text(exercise.name)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.gray.opacity(0.2))
                }
                .scrollContentBackground(.hidden)
                .background(Color.black)
            }
        }
        .navigationTitle("All Exercises")
    }
}

// Example detail
struct ExerciseDetailView: View {
    @EnvironmentObject var dataModel: DataModel
    let exercise: Exercise

    @State private var showImagePicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 16) {
                Text(exercise.name)
                    .font(.title)
                    .foregroundColor(.white)

                if let path = Bundle.main.path(forResource: exercise.gifName, ofType: nil) {
                    let fileUrl = URL(fileURLWithPath: path)
                    WebImage(url: fileUrl)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("GIF not found: \(exercise.gifName)")
                        .foregroundColor(.red)
                    Button("Upload GIF") {
                        showImagePicker = true
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }

                if let primary = exercise.primaryCategory {
                    Text("Primary Category: \(primary)")
                        .foregroundColor(.white)
                }
                if let second = exercise.secondaryCategory {
                    Text("Secondary Category: \(second)")
                        .foregroundColor(.white)
                }

                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker { pickedUrl in
                handlePickedGif(pickedUrl)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Upload GIF"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func handlePickedGif(_ url: URL) {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let ext = url.pathExtension.isEmpty ? "gif" : url.pathExtension
        let newName = exercise.name.replacingOccurrences(of: " ", with: "_") + "." + ext

        let newUrl = docs.appendingPathComponent(newName)
        do {
            if FileManager.default.fileExists(atPath: newUrl.path) {
                try FileManager.default.removeItem(at: newUrl)
            }
            try FileManager.default.copyItem(at: url, to: newUrl)
            dataModel.setGifPath(for: exercise.gifName, path: newUrl.path)
            alertMessage = "GIF uploaded successfully!"
        } catch {
            alertMessage = "Error copying file: \(error)"
        }
        showAlert = true
    }
}
