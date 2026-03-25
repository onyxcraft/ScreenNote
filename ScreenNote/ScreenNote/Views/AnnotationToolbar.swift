import SwiftUI

struct AnnotationToolbar: View {
    @EnvironmentObject var viewModel: AnnotationViewModel

    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 8) {
                ForEach([AnnotationType.arrow, .rectangle, .circle, .numberedCircle, .text, .highlight, .blur], id: \.self) { tool in
                    ToolButton(tool: tool, selectedTool: $viewModel.selectedTool)
                }
            }

            Divider()
                .frame(height: 30)

            ColorPicker("", selection: Binding(
                get: { Color(viewModel.selectedColor.nsColor) },
                set: { viewModel.selectedColor = CodableColor(nsColor: NSColor($0)) }
            ))
            .labelsHidden()
            .frame(width: 40)

            Divider()
                .frame(height: 30)

            Button(action: viewModel.undo) {
                Image(systemName: "arrow.uturn.backward")
            }
            .help("Undo")

            Spacer()

            Button("Copy") {
                viewModel.copyToClipboard()
            }

            Button("Save") {
                viewModel.saveToDesktop()
            }

            Button("Done") {
                viewModel.saveAndClose()
            }
            .keyboardShortcut(.return, modifiers: [.command])

            Button("Cancel") {
                viewModel.close()
            }
            .keyboardShortcut(.escape, modifiers: [])
        }
    }
}

struct ToolButton: View {
    let tool: AnnotationType
    @Binding var selectedTool: AnnotationType

    var body: some View {
        Button(action: {
            selectedTool = tool
        }) {
            Image(systemName: tool.iconName)
                .frame(width: 30, height: 30)
                .background(selectedTool == tool ? Color.accentColor.opacity(0.2) : Color.clear)
                .cornerRadius(6)
        }
        .buttonStyle(.plain)
        .help(tool.displayName)
    }
}
