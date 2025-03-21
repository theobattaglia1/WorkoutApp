import SwiftUI
import SDWebImageSwiftUI

struct UniversalExerciseFlowView: View {
    @EnvironmentObject var dataModel: DataModel
    @EnvironmentObject var stopwatch: StopwatchState

    let workoutName: String
    @State var exercises: [ScheduledExercise]

    var onFinish: (() -> Void)? = nil

    @State private var currentIndex = 0
    @State private var showStopwatch = true
    @State private var stopwatchExpanded = false

    @State private var showImagePicker = false
    @State private var alertMessage = ""
    @State private var showAlert = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if exercises.isEmpty || currentIndex < 0 || currentIndex >= exercises.count {
                VStack {
                    Text("No exercises found or invalid index.")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
            } else {
                let exercise = exercises[currentIndex]

                VStack(spacing: 8) {
                    // Top bar
                    HStack {
                        Button("Back") {
                            // Add navigation dismiss if needed
                        }
                        .foregroundColor(.white)

                        Spacer()

                        Slider(value: Binding(
                            get: { Double(currentIndex) },
                            set: { val in
                                let newI = Int(val)
                                if newI >= 0 && newI < exercises.count {
                                    currentIndex = newI
                                }
                            }
                        ), in: 0...Double(exercises.count - 1), step: 1)
                        .frame(width: 150)
                        .tint(.white)
                    }
                    .padding(.horizontal)

                    if showStopwatch {
                        HStack {
                            if stopwatchExpanded {
                                ExpandedStopwatchView(showStopwatch: $showStopwatch,
                                                      isExpanded: $stopwatchExpanded)
                                .frame(height: 120)
                            } else {
                                CollapsedStopwatchView(showStopwatch: $showStopwatch,
                                                       isExpanded: $stopwatchExpanded)
                                .frame(height: 40)
                            }
                        }
                    }

                    Text(exercise.exerciseName)
                        .font(.title)
                        .foregroundColor(.white)

                    displayGif(for: exercise)

                    if let instr = exercise.instructions {
                        Text("Instructions: \(instr)")
                            .foregroundColor(.white)
                    }

                    // Sets with checkboxes and weight input
                    ForEach(0..<exercise.sets.count, id: \.self) { sIdx in
                        let setItem = exercises[currentIndex].sets[sIdx]
                        HStack {
                            Button {
                                toggleSetCompleted(currentIndex, sIdx)
                            } label: {
                                Image(systemName: setItem.isCompleted ? "checkmark.square" : "square")
                                    .foregroundColor(.white)
                            }
                            Text("Reps: \(setItem.reps), Weight: \(setItem.weight)")
                                .foregroundColor(.white)
                            Spacer()
                            TextField("Used", text: Binding(
                                get: { setItem.recordedWeight },
                                set: { newVal in updateSetWeight(currentIndex, sIdx, newVal) }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 60)
                        }
                    }

                    if let restVal = exercise.rest {
                        Text("Rest: \(restVal)")
                            .foregroundColor(.white)
                    }

                    Spacer()

                    HStack {
                        Button("Previous") {
                            if currentIndex > 0 {
                                currentIndex -= 1
                            }
                        }
                        .disabled(currentIndex == 0)
                        .foregroundColor(currentIndex == 0 ? .gray : .white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(8)

                        Spacer()

                        Button("Next") {
                            if currentIndex < exercises.count - 1 {
                                currentIndex += 1
                            } else {
                                promptFinish()
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(8)
                    }
                    .padding()
                }
                .padding()
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker { pickedUrl in
                handlePickedGif(pickedUrl)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("GIF Upload"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    // Display GIF using layered approach
    @ViewBuilder
    private func displayGif(for exercise: ScheduledExercise) -> some View {
        // 1. Check for user override
        if let userPath = dataModel.gifPath(for: exercise.gifName),
           FileManager.default.fileExists(atPath: userPath) {
            WebImage(url: URL(fileURLWithPath: userPath))
                .resizable()
                .scaledToFit()
        }
        // 2. Try the original gifName from the exercise in the bundle
        else if let builtInPath = Bundle.main.path(forResource: exercise.gifName, ofType: nil) {
            WebImage(url: URL(fileURLWithPath: builtInPath))
                .resizable()
                .scaledToFit()
        }
        // 3. As a fallback, use fuzzy matching to guess a filename and try that.
        else {
            let guess = dataModel.findClosestGifName(for: exercise.exerciseName)
            if let builtInPath = Bundle.main.path(forResource: guess, ofType: nil) {
                WebImage(url: URL(fileURLWithPath: builtInPath))
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
        }
    }

    func toggleSetCompleted(_ exIdx: Int, _ sIdx: Int) {
        guard exIdx >= 0, exIdx < exercises.count else { return }
        guard sIdx >= 0, sIdx < exercises[exIdx].sets.count else { return }
        exercises[exIdx].sets[sIdx].isCompleted.toggle()
    }

    func updateSetWeight(_ exIdx: Int, _ sIdx: Int, _ newVal: String) {
        guard exIdx >= 0, exIdx < exercises.count else { return }
        guard sIdx >= 0, sIdx < exercises[exIdx].sets.count else { return }
        exercises[exIdx].sets[sIdx].recordedWeight = newVal
    }

    func promptFinish() {
        let alert = UIAlertController(title: "Finish Workout?",
                                      message: "You finished all exercises. Log this workout?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            if let finish = onFinish {
                finish()
            } else {
                dataModel.logWorkout(workoutName)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(alert, animated: true)
        }
    }

    private func handlePickedGif(_ pickedUrl: URL) {
        let gifKey = exercises[currentIndex].gifName
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let ext = pickedUrl.pathExtension.isEmpty ? "gif" : pickedUrl.pathExtension
        let newName = gifKey.replacingOccurrences(of: " ", with: "_") + "." + ext
        let newUrl = docs.appendingPathComponent(newName)
        do {
            if FileManager.default.fileExists(atPath: newUrl.path) {
                try FileManager.default.removeItem(at: newUrl)
            }
            try FileManager.default.copyItem(at: pickedUrl, to: newUrl)
            dataModel.setGifPath(for: gifKey, path: newUrl.path)
            alertMessage = "GIF uploaded successfully!"
        } catch {
            alertMessage = "Error copying file: \(error)"
        }
        showAlert = true
    }
}
