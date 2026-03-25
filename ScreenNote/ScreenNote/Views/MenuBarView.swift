import SwiftUI

struct MenuBarView: View {
    @StateObject private var annotationVM = AnnotationViewModel()
    @StateObject private var historyVM = HistoryViewModel()

    var body: some View {
        VStack(spacing: 0) {
            Button("New Screenshot") {
                annotationVM.startCapture()
            }
            .keyboardShortcut("a", modifiers: [.command, .shift])

            Divider()

            Button("History") {
                historyVM.isShowingHistory.toggle()
            }
            .keyboardShortcut("h", modifiers: [.command])

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q", modifiers: [.command])
        }
        .padding(.vertical, 4)
        .sheet(isPresented: $historyVM.isShowingHistory) {
            HistoryPanel()
                .environmentObject(historyVM)
        }
        .sheet(isPresented: $annotationVM.isAnnotating) {
            if let image = annotationVM.currentImage {
                AnnotationOverlayWindow(image: image)
                    .environmentObject(annotationVM)
            }
        }
    }
}
