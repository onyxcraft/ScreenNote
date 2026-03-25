import SwiftUI

struct AnnotationOverlayWindow: View {
    let image: NSImage
    @EnvironmentObject var viewModel: AnnotationViewModel
    @State private var showingTextInput = false
    @State private var textInputPosition: CGPoint = .zero

    var body: some View {
        VStack(spacing: 0) {
            AnnotationToolbar()
                .environmentObject(viewModel)
                .padding()
                .background(Color(NSColor.windowBackgroundColor))

            AnnotationCanvas(image: image)
                .environmentObject(viewModel)
                .onTapGesture { location in
                    if viewModel.selectedTool == .text {
                        textInputPosition = location
                        showingTextInput = true
                    }
                }
        }
        .frame(width: image.size.width + 200, height: image.size.height + 100)
        .alert("Add Text", isPresented: $showingTextInput) {
            TextField("Text", text: .constant(""))
                .onSubmit {
                    showingTextInput = false
                }
            Button("Cancel", role: .cancel) {
                showingTextInput = false
            }
            Button("Add") {
                showingTextInput = false
            }
        }
    }
}
