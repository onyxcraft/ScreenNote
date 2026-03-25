import Foundation

enum AnnotationType: String, Codable, CaseIterable {
    case arrow
    case text
    case highlight
    case blur
    case pixelate
    case rectangle
    case circle
    case numberedCircle
    case freehand

    var displayName: String {
        switch self {
        case .arrow: return "Arrow"
        case .text: return "Text"
        case .highlight: return "Highlight"
        case .blur: return "Blur"
        case .pixelate: return "Pixelate"
        case .rectangle: return "Rectangle"
        case .circle: return "Circle"
        case .numberedCircle: return "Number"
        case .freehand: return "Draw"
        }
    }

    var iconName: String {
        switch self {
        case .arrow: return "arrow.up.right"
        case .text: return "textformat"
        case .highlight: return "highlighter"
        case .blur: return "circle.hexagongrid.fill"
        case .pixelate: return "square.grid.3x3.fill"
        case .rectangle: return "rectangle"
        case .circle: return "circle"
        case .numberedCircle: return "circle.fill"
        case .freehand: return "pencil.tip"
        }
    }
}
