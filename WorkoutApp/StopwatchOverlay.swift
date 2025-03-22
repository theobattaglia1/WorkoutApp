import SwiftUI

struct StopwatchOverlay: View {
    @EnvironmentObject var stopwatchState: StopwatchState

    var body: some View {
        Group {
            if stopwatchState.isExpanded {
                expandedView
            } else {
                collapsedView
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                stopwatchState.isExpanded.toggle()
            }
        }
    }
    
    // Collapsed State: Small circle with elapsed time
    var collapsedView: some View {
        ZStack {
            Circle()
                .fill(Color("CardBackground"))
                .frame(width: 50, height: 50)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            Text(timeString())
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
        }
    }
    
    // Expanded State: Larger panel with controls
    var expandedView: some View {
        VStack(spacing: 16) {
            Text(timeString())
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
            HStack(spacing: 16) {
                Button(action: {
                    stopwatchState.start()
                }) {
                    Text("Start")
                        .frame(width: 60, height: 40)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                Button(action: {
                    stopwatchState.stop()
                }) {
                    Text("Stop")
                        .frame(width: 60, height: 40)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                Button(action: {
                    stopwatchState.reset()
                }) {
                    Text("Reset")
                        .frame(width: 60, height: 40)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
            }
        }
        .padding(20)
        .frame(width: 200, height: 200)
        .background(Color("CardBackground"))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 4)
    }
    
    // Formats the elapsed time as HH:MM:SS
    private func timeString() -> String {
        let seconds = Int(stopwatchState.elapsedTime) % 60
        let minutes = (Int(stopwatchState.elapsedTime) / 60) % 60
        let hours = Int(stopwatchState.elapsedTime) / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct StopwatchOverlay_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchOverlay()
            .environmentObject(StopwatchState())
    }
}
