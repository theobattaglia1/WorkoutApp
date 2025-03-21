import SwiftUI

extension Color {
    // Primary background: black
    static let primaryBackground = Color.black

    // Secondary background: dark grey
    static let secondaryBackground = Color(white: 0.15)

    // Primary text: white
    static let primaryText = Color.white

    // Secondary text: lighter grey
    static let secondaryText = Color(white: 0.7)

    // Border or shadow color
    static let borderGray = Color(white: 0.2)
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.secondaryBackground)
            .cornerRadius(12)
            .shadow(color: Color.borderGray.opacity(0.5), radius: 4, x: 0, y: 2)
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyle())
    }
}
