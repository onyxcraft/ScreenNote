import Foundation
import AppKit
import Combine

@MainActor
class HistoryViewModel: ObservableObject {
    @Published var screenshots: [Screenshot] = []
    @Published var isShowingHistory = false

    private let storageService = StorageService.shared

    init() {
        loadHistory()
    }

    func loadHistory() {
        screenshots = storageService.getHistory()
    }

    func deleteScreenshot(_ screenshot: Screenshot) {
        storageService.deleteScreenshot(screenshot)
        loadHistory()
    }

    func openScreenshot(_ screenshot: Screenshot) {
        guard let url = URL(string: screenshot.imagePath) else { return }
        NSWorkspace.shared.open(url)
    }

    func copyScreenshot(_ screenshot: Screenshot) {
        guard let image = screenshot.image else { return }
        storageService.copyToClipboard(image, annotations: screenshot.annotations)
    }

    func shareScreenshot(_ screenshot: Screenshot) {
        guard let url = URL(string: screenshot.imagePath) else { return }

        let picker = NSSharingServicePicker(items: [url])
        if let view = NSApp.keyWindow?.contentView {
            picker.show(relativeTo: .zero, of: view, preferredEdge: .minY)
        }
    }
}
