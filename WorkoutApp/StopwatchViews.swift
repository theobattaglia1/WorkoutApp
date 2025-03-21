import SwiftUI

struct CollapsedStopwatchView: View {
    @EnvironmentObject var stopwatch: StopwatchState
    @Binding var showStopwatch: Bool
    @Binding var isExpanded: Bool

    var body: some View {
        HStack {
            Text(stopwatch.formatTime())
                .foregroundColor(.white)
                .font(.headline)
            Spacer()

            Button {
                if stopwatch.isRunning {
                    stopwatch.stop()
                } else {
                    stopwatch.start()
                }
            } label: {
                Text(stopwatch.isRunning ? "Pause" : "Start")
                    .foregroundColor(.black)
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(6)
            }

            Button {
                stopwatch.reset()
            } label: {
                Text("Reset")
                    .foregroundColor(.black)
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(6)
            }

            Button {
                isExpanded.toggle()
            } label: {
                Text("Expand")
                    .foregroundColor(.black)
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(6)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.black.opacity(0.7))
        .cornerRadius(8)
    }
}

struct ExpandedStopwatchView: View {
    @EnvironmentObject var stopwatch: StopwatchState
    @Binding var showStopwatch: Bool
    @Binding var isExpanded: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.85)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                Text(stopwatch.formatTime())
                    .foregroundColor(.white)
                    .font(.system(size: 56, weight: .bold, design: .monospaced))
                    .padding(.top, 40)

                HStack(spacing: 20) {
                    Button {
                        if stopwatch.isRunning {
                            stopwatch.stop()
                        } else {
                            stopwatch.start()
                        }
                    } label: {
                        Text(stopwatch.isRunning ? "Pause" : "Start")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                    }

                    Button {
                        stopwatch.reset()
                    } label: {
                        Text("Reset")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                }

                Spacer()

                VStack(spacing: 20) {
                    Button {
                        isExpanded.toggle()
                    } label: {
                        Text("Collapse")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                    }

                    Button {
                        showStopwatch = false
                    } label: {
                        Text("Stop")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .zIndex(999)
    }
}
