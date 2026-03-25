import Foundation
import AppKit
import Combine

@MainActor
class AnnotationViewModel: ObservableObject {
    @Published var currentImage: NSImage?
    @Published var annotations: [Annotation] = []
    @Published var selectedTool: AnnotationType = .arrow
    @Published var selectedColor: CodableColor = CodableColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    @Published var lineWidth: CGFloat = 3.0
    @Published var isAnnotating = false
    @Published var currentAnnotation: Annotation?

    private var numberCounter = 1
    private let storageService = StorageService.shared

    func startCapture() {
        ScreenCaptureService.shared.captureRegion { [weak self] image in
            guard let self = self, let image = image else { return }
            Task { @MainActor in
                self.currentImage = image
                self.annotations = []
                self.numberCounter = 1
                self.isAnnotating = true
            }
        }
    }

    func beginAnnotation(at point: CGPoint) {
        let annotation = Annotation(
            type: selectedTool,
            startPoint: point,
            endPoint: point,
            color: selectedColor,
            lineWidth: lineWidth,
            number: selectedTool == .numberedCircle ? numberCounter : nil
        )

        if selectedTool == .numberedCircle {
            numberCounter += 1
            annotations.append(annotation)
        } else {
            currentAnnotation = annotation
        }
    }

    func updateAnnotation(to point: CGPoint) {
        guard var annotation = currentAnnotation else { return }
        annotation.endPoint = point
        currentAnnotation = annotation
    }

    func endAnnotation() {
        if let annotation = currentAnnotation {
            annotations.append(annotation)
            currentAnnotation = nil
        }
    }

    func addFreehandPoint(_ point: CGPoint) {
        if currentAnnotation == nil {
            var annotation = Annotation(
                type: .freehand,
                startPoint: point,
                color: selectedColor,
                lineWidth: lineWidth
            )
            annotation.path = [point]
            currentAnnotation = annotation
        } else if var annotation = currentAnnotation {
            var path = annotation.path ?? []
            path.append(point)
            annotation.path = path
            currentAnnotation = annotation
        }
    }

    func addText(_ text: String, at point: CGPoint) {
        let annotation = Annotation(
            type: .text,
            startPoint: point,
            color: selectedColor,
            lineWidth: lineWidth,
            text: text
        )
        annotations.append(annotation)
    }

    func undo() {
        if !annotations.isEmpty {
            annotations.removeLast()
        }
    }

    func copyToClipboard() {
        guard let image = currentImage else { return }
        storageService.copyToClipboard(image, annotations: annotations)
    }

    func saveToDesktop() {
        guard let image = currentImage else { return }
        _ = storageService.saveToDesktop(image, annotations: annotations)
    }

    func saveAndClose() {
        guard let image = currentImage else { return }
        _ = storageService.saveScreenshot(image, annotations: annotations)
        close()
    }

    func close() {
        currentImage = nil
        annotations = []
        numberCounter = 1
        isAnnotating = false
    }
}
