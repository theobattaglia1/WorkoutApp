import SwiftUI
import SDWebImageSwiftUI

struct LegacyExerciseDetailView: View {
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

                // 1) Check userGifPaths
                if let localGifPath = dataModel.gifPath(for: exercise.name),
                   FileManager.default.fileExists(atPath: localGifPath) {
                    let fileUrl = URL(fileURLWithPath: localGifPath)
                    WebImage(url: fileUrl)
                        .resizable()
                        .scaledToFit()
                } else {
                    // 2) fallback to built-in
                    if let path = Bundle.main.path(forResource: exercise.gifName, ofType: nil) {
                        let fileUrl = URL(fileURLWithPath: path)
                        WebImage(url: fileUrl)
                            .resizable()
                            .scaledToFit()
                    } else {
                        // No GIF found
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
            ImagePicker(onPicked: handlePickedGif)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Upload GIF"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }

    private func handlePickedGif(_ pickedUrl: URL) {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let ext = pickedUrl.pathExtension.isEmpty ? "gif" : pickedUrl.pathExtension
        let newName = exercise.name.replacingOccurrences(of: " ", with: "_") + "." + ext
        let newUrl = docs.appendingPathComponent(newName)
        do {
            if FileManager.default.fileExists(atPath: newUrl.path) {
                try FileManager.default.removeItem(at: newUrl)
            }
            try FileManager.default.copyItem(at: pickedUrl, to: newUrl)
            dataModel.setGifPath(for: exercise.name, path: newUrl.path)
            alertMessage = "GIF uploaded successfully!"
        } catch {
            alertMessage = "Error copying file: \(error)"
        }
        showAlert = true
    }
}
