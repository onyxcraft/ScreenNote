//
//  AnnotationTool.swift
//  ScreenNote
//
//  Created by ScreenNote on 2026-03-25.
//

import Foundation
import SwiftUI

enum AnnotationTool: String, CaseIterable, Identifiable {
    case arrow
    case text
    case highlight
    case blur
    case rectangle
    case circle
    case numbering
    case crop

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .arrow: return "Arrow"
        case .text: return "Text"
        case .highlight: return "Highlight"
        case .blur: return "Blur"
        case .rectangle: return "Rectangle"
        case .circle: return "Circle"
        case .numbering: return "Numbering"
        case .crop: return "Crop"
        }
    }

    var icon: String {
        switch self {
        case .arrow: return "arrow.up.right"
        case .text: return "textformat"
        case .highlight: return "highlighter"
        case .rectangle: return "rectangle"
        case .circle: return "circle"
        case .blur: return "eye.slash"
        case .numbering: return "number.circle"
        case .crop: return "crop"
        }
    }
}

enum ToolStyle {
    case arrow(color: NSColor, thickness: CGFloat)
    case text(color: NSColor, fontSize: CGFloat, font: NSFont)
    case highlight(color: NSColor, thickness: CGFloat, opacity: CGFloat)
    case blur(radius: CGFloat)
    case shape(color: NSColor, thickness: CGFloat, filled: Bool)
    case number(color: NSColor, backgroundColor: NSColor, number: Int)

    static var defaultArrow: ToolStyle {
        .arrow(color: .systemRed, thickness: 3.0)
    }

    static var defaultText: ToolStyle {
        .text(color: .black, fontSize: 16.0, font: .systemFont(ofSize: 16))
    }

    static var defaultHighlight: ToolStyle {
        .highlight(color: .systemYellow, thickness: 20.0, opacity: 0.5)
    }

    static var defaultBlur: ToolStyle {
        .blur(radius: 10.0)
    }

    static var defaultShape: ToolStyle {
        .shape(color: .systemBlue, thickness: 2.0, filled: false)
    }

    static func defaultNumber(_ num: Int) -> ToolStyle {
        .number(color: .white, backgroundColor: .systemBlue, number: num)
    }
}
