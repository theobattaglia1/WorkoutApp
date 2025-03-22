import SwiftUI

struct LegacyExerciseDetailView: View {
    @EnvironmentObject var dataModel: DataModel
    let exercise: Exercise
    
    @State private var gifUrl: URL? = nil
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                // Display exercise title (replacing 'name' with 'title')
                Text(exercise.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                // Display exercise details
                Text(exercise.details)
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
                
                // Display GIF if available; else, show a button to load it.
                if let gifUrl = gifUrl {
                    AsyncImage(url: gifUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 200)
                    .padding()
                } else {
                    Button("Load GIF") {
                        loadGifForExercise()
                    }
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                }
                
                Spacer()
            }
        }
        .navigationTitle("Exercise Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func loadGifForExercise() {
        // Placeholder fuzzy matching logic:
        // In a production app, you'd match the exercise title against available GIF filenames.
        // Here, we simulate loading a GIF URL.
        if let url = URL(string: "https://media.giphy.com/media/26BRuo6sLetdllPAQ/giphy.gif") {
            gifUrl = url
            // If a method existed to store the matched GIF path, it might be called here.
            // For example:
            // dataModel.setGifPath(for: exercise.title, path: url.path)
        }
    }
}

struct LegacyExerciseDetailView_Previews: PreviewProvider {
    static let sampleExercise = Exercise(title: "Push Ups", details: "3 sets x 12 reps")
    
    static var previews: some View {
        NavigationStack {
            LegacyExerciseDetailView(exercise: sampleExercise)
                .environmentObject(DataModel())
        }
    }
}
