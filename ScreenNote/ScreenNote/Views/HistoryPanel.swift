import SwiftUI

struct HistoryPanel: View {
    @EnvironmentObject var viewModel: HistoryViewModel

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.screenshots.isEmpty {
                    ContentUnavailableView(
                        "No Screenshots",
                        systemImage: "photo.on.rectangle.angled",
                        description: Text("Your screenshot history will appear here")
                    )
                } else {
                    List {
                        ForEach(viewModel.screenshots) { screenshot in
                            HistoryRow(screenshot: screenshot)
                                .environmentObject(viewModel)
                        }
                    }
                }
            }
            .navigationTitle("Screenshot History")
            .frame(minWidth: 600, minHeight: 400)
        }
    }
}

struct HistoryRow: View {
    let screenshot: Screenshot
    @EnvironmentObject var viewModel: HistoryViewModel

    var body: some View {
        HStack(spacing: 12) {
            if let thumbnail = screenshot.thumbnailImage {
                Image(nsImage: thumbnail)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 75)
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 75)
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(screenshot.timestamp, style: .date)
                    .font(.headline)
                Text(screenshot.timestamp, style: .time)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(screenshot.annotations.count) annotations")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            HStack(spacing: 8) {
                Button(action: { viewModel.openScreenshot(screenshot) }) {
                    Image(systemName: "eye")
                }
                .help("View")

                Button(action: { viewModel.copyScreenshot(screenshot) }) {
                    Image(systemName: "doc.on.doc")
                }
                .help("Copy")

                Button(action: { viewModel.shareScreenshot(screenshot) }) {
                    Image(systemName: "square.and.arrow.up")
                }
                .help("Share")

                Button(action: { viewModel.deleteScreenshot(screenshot) }) {
                    Image(systemName: "trash")
                }
                .foregroundColor(.red)
                .help("Delete")
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
    }
}
