import SwiftUI

struct SettingsView: View {
    @AppStorage("hotkey") private var hotkey: String = "Cmd+Shift+A"

    var body: some View {
        Form {
            Section("Hotkeys") {
                LabeledContent("Screenshot") {
                    Text(hotkey)
                        .foregroundColor(.secondary)
                }
            }

            Section("About") {
                LabeledContent("Version") {
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                LabeledContent("Bundle ID") {
                    Text("com.lopodragon.screennote")
                        .foregroundColor(.secondary)
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 450, height: 300)
    }
}
