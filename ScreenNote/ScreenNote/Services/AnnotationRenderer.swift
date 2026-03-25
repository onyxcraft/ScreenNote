import Foundation
import AppKit
import CoreGraphics

class AnnotationRenderer {
    func renderAnnotations(on image: NSImage, annotations: [Annotation]) -> NSImage? {
        let size = image.size
        let renderImage = NSImage(size: size)

        renderImage.lockFocus()

        image.draw(at: .zero, from: NSRect(origin: .zero, size: size), operation: .copy, fraction: 1.0)

        let context = NSGraphicsContext.current?.cgContext
        context?.saveGState()

        for annotation in annotations {
            renderAnnotation(annotation, in: context)
        }

        context?.restoreGState()
        renderImage.unlockFocus()

        return renderImage
    }

    private func renderAnnotation(_ annotation: Annotation, in context: CGContext?) {
        guard let context = context else { return }

        context.setStrokeColor(annotation.color.nsColor.cgColor)
        context.setFillColor(annotation.color.nsColor.cgColor)
        context.setLineWidth(annotation.lineWidth)

        switch annotation.type {
        case .arrow:
            drawArrow(from: annotation.startPoint, to: annotation.endPoint, in: context)
        case .rectangle:
            drawRectangle(from: annotation.startPoint, to: annotation.endPoint, in: context)
        case .circle:
            drawCircle(from: annotation.startPoint, to: annotation.endPoint, in: context)
        case .highlight:
            drawHighlight(from: annotation.startPoint, to: annotation.endPoint, in: context)
        case .blur:
            drawBlur(from: annotation.startPoint, to: annotation.endPoint, in: context)
        case .pixelate:
            drawPixelate(from: annotation.startPoint, to: annotation.endPoint, in: context)
        case .text:
            if let text = annotation.text {
                drawText(text, at: annotation.startPoint, in: context)
            }
        case .numberedCircle:
            if let number = annotation.number {
                drawNumberedCircle(number, at: annotation.startPoint, in: context)
            }
        case .freehand:
            if let path = annotation.path {
                drawFreehand(path: path, in: context)
            }
        }
    }

    private func drawArrow(from start: CGPoint, to end: CGPoint, in context: CGContext) {
        context.beginPath()
        context.move(to: start)
        context.addLine(to: end)
        context.strokePath()

        let angle = atan2(end.y - start.y, end.x - start.x)
        let arrowLength: CGFloat = 15
        let arrowAngle: CGFloat = .pi / 6

        let arrowPoint1 = CGPoint(
            x: end.x - arrowLength * cos(angle - arrowAngle),
            y: end.y - arrowLength * sin(angle - arrowAngle)
        )
        let arrowPoint2 = CGPoint(
            x: end.x - arrowLength * cos(angle + arrowAngle),
            y: end.y - arrowLength * sin(angle + arrowAngle)
        )

        context.beginPath()
        context.move(to: end)
        context.addLine(to: arrowPoint1)
        context.move(to: end)
        context.addLine(to: arrowPoint2)
        context.strokePath()
    }

    private func drawRectangle(from start: CGPoint, to end: CGPoint, in context: CGContext) {
        let rect = CGRect(
            x: min(start.x, end.x),
            y: min(start.y, end.y),
            width: abs(end.x - start.x),
            height: abs(end.y - start.y)
        )
        context.stroke(rect)
    }

    private func drawCircle(from start: CGPoint, to end: CGPoint, in context: CGContext) {
        let rect = CGRect(
            x: min(start.x, end.x),
            y: min(start.y, end.y),
            width: abs(end.x - start.x),
            height: abs(end.y - start.y)
        )
        context.strokeEllipse(in: rect)
    }

    private func drawHighlight(from start: CGPoint, to end: CGPoint, in context: CGContext) {
        context.setAlpha(0.3)
        let rect = CGRect(
            x: min(start.x, end.x),
            y: min(start.y, end.y),
            width: abs(end.x - start.x),
            height: abs(end.y - start.y)
        )
        context.fill(rect)
        context.setAlpha(1.0)
    }

    private func drawBlur(from start: CGPoint, to end: CGPoint, in context: CGContext) {
        let rect = CGRect(
            x: min(start.x, end.x),
            y: min(start.y, end.y),
            width: abs(end.x - start.x),
            height: abs(end.y - start.y)
        )
        context.setFillColor(NSColor.white.withAlphaComponent(0.5).cgColor)
        context.fill(rect)
    }

    private func drawPixelate(from start: CGPoint, to end: CGPoint, in context: CGContext) {
        let rect = CGRect(
            x: min(start.x, end.x),
            y: min(start.y, end.y),
            width: abs(end.x - start.x),
            height: abs(end.y - start.y)
        )

        let pixelSize: CGFloat = 10
        let cols = Int(rect.width / pixelSize)
        let rows = Int(rect.height / pixelSize)

        for row in 0..<rows {
            for col in 0..<cols {
                let pixelRect = CGRect(
                    x: rect.minX + CGFloat(col) * pixelSize,
                    y: rect.minY + CGFloat(row) * pixelSize,
                    width: pixelSize,
                    height: pixelSize
                )

                let gray = CGFloat.random(in: 0.3...0.7)
                context.setFillColor(NSColor(white: gray, alpha: 1.0).cgColor)
                context.fill(pixelRect)
            }
        }
    }

    private func drawText(_ text: String, at point: CGPoint, in context: CGContext) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: NSColor.red
        ]

        let attributedString = NSAttributedString(string: text, attributes: attributes)
        attributedString.draw(at: point)
    }

    private func drawNumberedCircle(_ number: Int, at point: CGPoint, in context: CGContext) {
        let radius: CGFloat = 20
        let circleRect = CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)

        context.fillEllipse(in: circleRect)

        let text = "\(number)"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: NSColor.white
        ]

        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let textSize = attributedString.size()
        let textPoint = CGPoint(
            x: point.x - textSize.width / 2,
            y: point.y - textSize.height / 2
        )

        attributedString.draw(at: textPoint)
    }

    private func drawFreehand(path: [CGPoint], in context: CGContext) {
        guard path.count > 1 else { return }

        context.beginPath()
        context.move(to: path[0])

        for point in path.dropFirst() {
            context.addLine(to: point)
        }

        context.strokePath()
    }
}
