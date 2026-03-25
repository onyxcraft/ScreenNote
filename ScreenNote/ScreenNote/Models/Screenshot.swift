import Foundation
import AppKit

struct Screenshot: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let imagePath: String
    var annotations: [Annotation]

    init(id: UUID = UUID(), timestamp: Date = Date(), imagePath: String, annotations: [Annotation] = []) {
        self.id = id
        self.timestamp = timestamp
        self.imagePath = imagePath
        self.annotations = annotations
    }

    var image: NSImage? {
        guard let url = URL(string: imagePath) else { return nil }
        return NSImage(contentsOf: url)
    }

    var thumbnailImage: NSImage? {
        guard let original = image else { return nil }
        let targetSize = NSSize(width: 200, height: 150)
        let thumbnail = NSImage(size: targetSize)

        thumbnail.lockFocus()
        original.draw(in: NSRect(origin: .zero, size: targetSize),
                     from: NSRect(origin: .zero, size: original.size),
                     operation: .copy,
                     fraction: 1.0)
        thumbnail.unlockFocus()

        return thumbnail
    }
}
