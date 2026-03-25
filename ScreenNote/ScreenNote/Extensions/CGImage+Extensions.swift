import Foundation
import CoreGraphics
import AppKit

extension CGImage {
    func cropped(to rect: CGRect) -> CGImage? {
        return self.cropping(to: rect)
    }

    var nsImage: NSImage {
        NSImage(cgImage: self, size: NSSize(width: self.width, height: self.height))
    }
}

extension CGRect {
    func normalized(in bounds: CGRect) -> CGRect {
        return CGRect(
            x: max(bounds.minX, min(bounds.maxX, self.minX)),
            y: max(bounds.minY, min(bounds.maxY, self.minY)),
            width: min(bounds.maxX - self.minX, max(0, self.width)),
            height: min(bounds.maxY - self.minY, max(0, self.height))
        )
    }
}
