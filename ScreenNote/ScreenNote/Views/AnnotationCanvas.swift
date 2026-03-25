import SwiftUI

struct AnnotationCanvas: View {
    let image: NSImage
    @EnvironmentObject var viewModel: AnnotationViewModel
    @State private var dragStart: CGPoint?

    var body: some View {
        ZStack {
            Image(nsImage: image)
                .resizable()
                .scaledToFit()

            Canvas { context, size in
                for annotation in viewModel.annotations {
                    drawAnnotation(annotation, in: context, size: size)
                }

                if let current = viewModel.currentAnnotation {
                    drawAnnotation(current, in: context, size: size)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if dragStart == nil {
                            dragStart = value.location
                            if viewModel.selectedTool == .freehand {
                                viewModel.addFreehandPoint(value.location)
                            } else {
                                viewModel.beginAnnotation(at: value.location)
                            }
                        } else {
                            if viewModel.selectedTool == .freehand {
                                viewModel.addFreehandPoint(value.location)
                            } else {
                                viewModel.updateAnnotation(to: value.location)
                            }
                        }
                    }
                    .onEnded { _ in
                        viewModel.endAnnotation()
                        dragStart = nil
                    }
            )
        }
        .frame(width: image.size.width, height: image.size.height)
    }

    private func drawAnnotation(_ annotation: Annotation, in context: GraphicsContext, size: CGSize) {
        let color = Color(annotation.color.nsColor)

        switch annotation.type {
        case .arrow:
            drawArrow(from: annotation.startPoint, to: annotation.endPoint, color: color, lineWidth: annotation.lineWidth, in: context)
        case .rectangle:
            drawRectangle(from: annotation.startPoint, to: annotation.endPoint, color: color, lineWidth: annotation.lineWidth, in: context)
        case .circle:
            drawCircle(from: annotation.startPoint, to: annotation.endPoint, color: color, lineWidth: annotation.lineWidth, in: context)
        case .highlight:
            drawHighlight(from: annotation.startPoint, to: annotation.endPoint, color: color, in: context)
        case .blur:
            drawBlur(from: annotation.startPoint, to: annotation.endPoint, in: context)
        case .text:
            if let text = annotation.text {
                drawText(text, at: annotation.startPoint, color: color, in: context)
            }
        case .numberedCircle:
            if let number = annotation.number {
                drawNumberedCircle(number, at: annotation.startPoint, color: color, in: context)
            }
        case .freehand:
            if let path = annotation.path {
                drawFreehand(path: path, color: color, lineWidth: annotation.lineWidth, in: context)
            }
        default:
            break
        }
    }

    private func drawArrow(from start: CGPoint, to end: CGPoint, color: Color, lineWidth: CGFloat, in context: GraphicsContext) {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)

        context.stroke(path, with: .color(color), lineWidth: lineWidth)

        let angle = atan2(end.y - start.y, end.x - start.x)
        let arrowLength: CGFloat = 15
        let arrowAngle: CGFloat = .pi / 6

        var arrowPath = Path()
        arrowPath.move(to: end)
        arrowPath.addLine(to: CGPoint(
            x: end.x - arrowLength * cos(angle - arrowAngle),
            y: end.y - arrowLength * sin(angle - arrowAngle)
        ))
        arrowPath.move(to: end)
        arrowPath.addLine(to: CGPoint(
            x: end.x - arrowLength * cos(angle + arrowAngle),
            y: end.y - arrowLength * sin(angle + arrowAngle)
        ))

        context.stroke(arrowPath, with: .color(color), lineWidth: lineWidth)
    }

    private func drawRectangle(from start: CGPoint, to end: CGPoint, color: Color, lineWidth: CGFloat, in context: GraphicsContext) {
        let rect = CGRect(
            x: min(start.x, end.x),
            y: min(start.y, end.y),
            width: abs(end.x - start.x),
            height: abs(end.y - start.y)
        )

        var path = Path()
        path.addRect(rect)
        context.stroke(path, with: .color(color), lineWidth: lineWidth)
    }

    private func drawCircle(from start: CGPoint, to end: CGPoint, color: Color, lineWidth: CGFloat, in context: GraphicsContext) {
        let rect = CGRect(
            x: min(start.x, end.x),
            y: min(start.y, end.y),
            width: abs(end.x - start.x),
            height: abs(end.y - start.y)
        )

        var path = Path()
        path.addEllipse(in: rect)
        context.stroke(path, with: .color(color), lineWidth: lineWidth)
    }

    private func drawHighlight(from start: CGPoint, to end: CGPoint, color: Color, in context: GraphicsContext) {
        let rect = CGRect(
            x: min(start.x, end.x),
            y: min(start.y, end.y),
            width: abs(end.x - start.x),
            height: abs(end.y - start.y)
        )

        var path = Path()
        path.addRect(rect)
        context.fill(path, with: .color(color.opacity(0.3)))
    }

    private func drawBlur(from start: CGPoint, to end: CGPoint, in context: GraphicsContext) {
        let rect = CGRect(
            x: min(start.x, end.x),
            y: min(start.y, end.y),
            width: abs(end.x - start.x),
            height: abs(end.y - start.y)
        )

        var path = Path()
        path.addRect(rect)
        context.fill(path, with: .color(.white.opacity(0.5)))
    }

    private func drawText(_ text: String, at point: CGPoint, color: Color, in context: GraphicsContext) {
        context.draw(Text(text).foregroundColor(color).font(.system(size: 16, weight: .medium)), at: point)
    }

    private func drawNumberedCircle(_ number: Int, at point: CGPoint, color: Color, in context: GraphicsContext) {
        let radius: CGFloat = 20
        let circleRect = CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)

        var path = Path()
        path.addEllipse(in: circleRect)
        context.fill(path, with: .color(color))

        context.draw(
            Text("\(number)")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold)),
            at: point
        )
    }

    private func drawFreehand(path: [CGPoint], color: Color, lineWidth: CGFloat, in context: GraphicsContext) {
        guard path.count > 1 else { return }

        var bezierPath = Path()
        bezierPath.move(to: path[0])

        for point in path.dropFirst() {
            bezierPath.addLine(to: point)
        }

        context.stroke(bezierPath, with: .color(color), lineWidth: lineWidth)
    }
}
