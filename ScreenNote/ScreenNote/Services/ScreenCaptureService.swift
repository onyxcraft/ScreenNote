import Foundation
import AppKit
import ScreenCaptureKit

@MainActor
class ScreenCaptureService: ObservableObject {
    static let shared = ScreenCaptureService()

    private init() {}

    func captureRegion(completion: @escaping (NSImage?) -> Void) {
        Task {
            guard let screenshot = await performInteractiveScreenshot() else {
                completion(nil)
                return
            }
            completion(screenshot)
        }
    }

    private func performInteractiveScreenshot() async -> NSImage? {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
        task.arguments = ["-i", "-c"]

        do {
            try task.run()
            task.waitUntilExit()

            if task.terminationStatus == 0 {
                return NSPasteboard.general.readImage()
            }
        } catch {
            print("Screenshot capture failed: \(error)")
        }

        return nil
    }

    func requestScreenRecordingPermission() -> Bool {
        if #available(macOS 14.0, *) {
            let content = SCShareableContent.self
            Task {
                do {
                    _ = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
                } catch {
                    print("Screen recording permission check failed: \(error)")
                }
            }
        }
        return true
    }
}

extension NSPasteboard {
    func readImage() -> NSImage? {
        guard let data = data(forType: .tiff) else { return nil }
        return NSImage(data: data)
    }
}
