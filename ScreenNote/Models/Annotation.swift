//
//  Annotation.swift
//  ScreenNote
//
//  Created by ScreenNote on 2026-03-25.
//

import Foundation
import AppKit

struct Annotation: Identifiable, Codable {
    let id: UUID
    let tool: AnnotationTool
    var points: [CGPoint]
    var text: String?
    var style: AnnotationStyleData

    init(id: UUID = UUID(), tool: AnnotationTool, points: [CGPoint], text: String? = nil, style: AnnotationStyleData) {
        self.id = id
        self.tool = tool
        self.points = points
        self.text = text
        self.style = style
    }
}

struct AnnotationStyleData: Codable {
    var colorData: Data?
    var backgroundColorData: Data?
    var thickness: CGFloat
    var fontSize: CGFloat
    var opacity: CGFloat
    var filled: Bool
    var number: Int?

    var color: NSColor {
        get {
            guard let data = colorData,
                  let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data) else {
                return .systemRed
            }
            return color
        }
        set {
            colorData = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false)
        }
    }

    var backgroundColor: NSColor {
        get {
            guard let data = backgroundColorData,
                  let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data) else {
                return .systemBlue
            }
            return color
        }
        set {
            backgroundColorData = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false)
        }
    }

    static func from(toolStyle: ToolStyle) -> AnnotationStyleData {
        var style = AnnotationStyleData(thickness: 2.0, fontSize: 16.0, opacity: 1.0, filled: false)

        switch toolStyle {
        case .arrow(let color, let thickness):
            style.color = color
            style.thickness = thickness
        case .text(let color, let fontSize, _):
            style.color = color
            style.fontSize = fontSize
        case .highlight(let color, let thickness, let opacity):
            style.color = color
            style.thickness = thickness
            style.opacity = opacity
        case .blur(let radius):
            style.thickness = radius
        case .shape(let color, let thickness, let filled):
            style.color = color
            style.thickness = thickness
            style.filled = filled
        case .number(let color, let bgColor, let number):
            style.color = color
            style.backgroundColor = bgColor
            style.number = number
        }

        return style
    }
}
