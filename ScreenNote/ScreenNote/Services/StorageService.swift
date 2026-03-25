import Foundation
import AppKit

class StorageService {
    static let shared = StorageService()

    private let screenshotsDirectory: URL
    private let historyKey = "ScreenNoteHistory"
    private let maxHistoryItems = 50

    private init() {
        let applicationSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        screenshotsDirectory = applicationSupport.appendingPathComponent("ScreenNote/Screenshots")

        try? FileManager.default.createDirectory(at: screenshotsDirectory, withIntermediateDirectories: true)
    }

    func saveScreenshot(_ image: NSImage, annotations: [Annotation]) -> Screenshot? {
        let filename = "screenshot_\(Date().timeIntervalSince1970).png"
        let fileURL = screenshotsDirectory.appendingPathComponent(filename)

        guard let tiffData = image.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffData),
              let pngData = bitmapImage.representation(using: .png, properties: [:]) else {
            return nil
        }

        do {
            try pngData.write(to: fileURL)
            let screenshot = Screenshot(imagePath: fileURL.path, annotations: annotations)
            addToHistory(screenshot)
            return screenshot
        } catch {
            print("Failed to save screenshot: \(error)")
            return nil
        }
    }

    func saveToDesktop(_ image: NSImage, annotations: [Annotation]) -> URL? {
        guard let desktop = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first else {
            return nil
        }

        let renderer = AnnotationRenderer()
        guard let annotatedImage = renderer.renderAnnotations(on: image, annotations: annotations) else {
            return nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' HH.mm.ss"
        let filename = "ScreenNote \(dateFormatter.string(from: Date())).png"
        let fileURL = desktop.appendingPathComponent(filename)

        guard let tiffData = annotatedImage.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffData),
              let pngData = bitmapImage.representation(using: .png, properties: [:]) else {
            return nil
        }

        do {
            try pngData.write(to: fileURL)
            return fileURL
        } catch {
            print("Failed to save to desktop: \(error)")
            return nil
        }
    }

    func copyToClipboard(_ image: NSImage, annotations: [Annotation]) {
        let renderer = AnnotationRenderer()
        guard let annotatedImage = renderer.renderAnnotations(on: image, annotations: annotations) else {
            return
        }

        guard let tiffData = annotatedImage.tiffRepresentation else { return }

        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setData(tiffData, forType: .tiff)
    }

    func getHistory() -> [Screenshot] {
        guard let data = UserDefaults.standard.data(forKey: historyKey) else {
            return []
        }

        do {
            let screenshots = try JSONDecoder().decode([Screenshot].self, from: data)
            return screenshots.sorted { $0.timestamp > $1.timestamp }
        } catch {
            print("Failed to load history: \(error)")
            return []
        }
    }

    func addToHistory(_ screenshot: Screenshot) {
        var history = getHistory()
        history.insert(screenshot, at: 0)

        if history.count > maxHistoryItems {
            history = Array(history.prefix(maxHistoryItems))
        }

        do {
            let data = try JSONEncoder().encode(history)
            UserDefaults.standard.set(data, forKey: historyKey)
        } catch {
            print("Failed to save history: \(error)")
        }
    }

    func deleteScreenshot(_ screenshot: Screenshot) {
        if let url = URL(string: screenshot.imagePath) {
            try? FileManager.default.removeItem(at: url)
        }

        var history = getHistory()
        history.removeAll { $0.id == screenshot.id }

        do {
            let data = try JSONEncoder().encode(history)
            UserDefaults.standard.set(data, forKey: historyKey)
        } catch {
            print("Failed to update history: \(error)")
        }
    }
}
