import SwiftUI

struct Theme {
    // MARK: - Colors
    static let background = Color.black
    static let primaryText = Color.white
    static let secondaryText = Color.gray
    // Card background should be defined in your Assets as "CardBackground".
    static let cardBackground = Color("CardBackground")
    
    // MARK: - Fonts
    static func headingFont() -> Font {
        .system(size: 36, weight: .bold)
    }
    
    static func subheadingFont() -> Font {
        .system(size: 28, weight: .bold)
    }
    
    static func bodyFont() -> Font {
        .system(size: 18, weight: .regular)
    }
    
    static func buttonFont() -> Font {
        .system(size: 20, weight: .medium)
    }
    
    // MARK: - Spacing & Sizing
    static let horizontalPadding: CGFloat = 20
    static let verticalPadding: CGFloat = 20
    static let cardCornerRadius: CGFloat = 8
    static let cardShadowRadius: CGFloat = 4
    static let cardShadowOpacity: Double = 0.1
}

extension View {
    /// Applies a consistent card style for container views.
    func cardStyle() -> some View {
        self
            .padding(16)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cardCornerRadius)
            .shadow(color: Color.black.opacity(Theme.cardShadowOpacity),
                    radius: Theme.cardShadowRadius, x: 0, y: 2)
    }
    
    /// Applies a consistent style for primary buttons.
    func primaryButtonStyle() -> some View {
        self
            .font(Theme.buttonFont())
            .foregroundColor(.black)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: Theme.cardShadowRadius)
    }
}
