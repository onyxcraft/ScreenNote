import SwiftUI
import AppKit

extension Color {
    static let annotationRed = Color(red: 1.0, green: 0.0, blue: 0.0)
    static let annotationBlue = Color(red: 0.0, green: 0.5, blue: 1.0)
    static let annotationGreen = Color(red: 0.0, green: 0.8, blue: 0.0)
    static let annotationYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let annotationOrange = Color(red: 1.0, green: 0.5, blue: 0.0)
    static let annotationPurple = Color(red: 0.6, green: 0.0, blue: 0.8)

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
