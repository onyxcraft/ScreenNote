import Cocoa
import SwiftUI
import Carbon

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    private let hotKeyService = HotKeyService.shared

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        setupHotKey()
        requestScreenRecordingPermission()
    }

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "camera.viewfinder", accessibilityDescription: "ScreenNote")
            button.action = #selector(togglePopover)
        }

        let popover = NSPopover()
        popover.contentSize = NSSize(width: 200, height: 150)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: MenuBarView())

        self.popover = popover
    }

    @objc private func togglePopover() {
        guard let button = statusItem?.button else { return }

        if let popover = popover {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }

    private func setupHotKey() {
        hotKeyService.register(key: UInt32(kVK_ANSI_A), modifiers: UInt32(cmdKey | shiftKey)) { [weak self] in
            self?.triggerScreenCapture()
        }
    }

    private func triggerScreenCapture() {
        NotificationCenter.default.post(name: NSNotification.Name("TriggerScreenCapture"), object: nil)
    }

    private func requestScreenRecordingPermission() {
        _ = ScreenCaptureService.shared.requestScreenRecordingPermission()
    }

    func applicationWillTerminate(_ notification: Notification) {
        hotKeyService.unregister()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}
