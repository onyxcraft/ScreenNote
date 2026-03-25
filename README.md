# ScreenNote

A powerful and intuitive screenshot annotation tool for macOS 14+.

![ScreenNote](https://img.shields.io/badge/platform-macOS%2014%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Price](https://img.shields.io/badge/price-%243.99-orange)

## Features

- **Instant Capture**: Global hotkey `Cmd+Shift+A` to capture any screen region
- **Rich Annotations**:
  - Arrows
  - Text labels
  - Highlight areas
  - Blur/pixelate sensitive information
  - Rectangles and circles
  - Numbered circles for step-by-step guides
  - Freehand drawing
  - Crop functionality
- **Quick Actions**:
  - Copy to clipboard
  - Save to Desktop
  - Share via macOS share sheet
- **Menu Bar App**: Lightweight, always accessible from your menu bar
- **History Panel**: Browse and manage all your annotated screenshots
- **Dark Mode**: Full support for macOS dark mode

## Requirements

- macOS 14.0 or later
- Screen recording permission (requested on first launch)

## Installation

### From Source

1. Clone this repository
2. Open `ScreenNote.xcodeproj` in Xcode 15+
3. Build and run (Cmd+R)
4. Grant screen recording permission when prompted

### App Store

Available for $3.99 USD (one-time purchase)
Bundle ID: `com.lopodragon.screennote`

## Usage

### Taking a Screenshot

1. Press `Cmd+Shift+A` anywhere on your Mac
2. Click and drag to select the area to capture
3. The annotation overlay will appear automatically

### Annotating

1. Select an annotation tool from the toolbar
2. Draw or place annotations on your screenshot
3. Use the color picker to change colors
4. Press `Cmd+Z` or click Undo to remove the last annotation

### Saving Your Work

- **Copy**: Click "Copy" to copy the annotated screenshot to clipboard
- **Save**: Click "Save" to save as PNG to your Desktop
- **Share**: Use the share sheet to send via Messages, Mail, etc.
- **Done**: Click "Done" to save to history and close

### Viewing History

1. Click the ScreenNote icon in the menu bar
2. Select "History" or press `Cmd+H`
3. Browse, copy, share, or delete previous screenshots

## Architecture

ScreenNote is built with modern macOS development best practices:

- **SwiftUI**: Modern declarative UI framework
- **AppKit**: Native macOS integration for menu bar and screen capture
- **MVVM**: Clean separation of concerns
- **Core Graphics**: High-performance annotation rendering
- **No External Dependencies**: Pure Swift implementation

## Project Structure

```
ScreenNote/
├── Models/
│   ├── Screenshot.swift
│   ├── Annotation.swift
│   └── AnnotationType.swift
├── Views/
│   ├── MenuBarView.swift
│   ├── AnnotationOverlayWindow.swift
│   ├── AnnotationCanvas.swift
│   ├── AnnotationToolbar.swift
│   ├── HistoryPanel.swift
│   └── SettingsView.swift
├── ViewModels/
│   ├── AnnotationViewModel.swift
│   └── HistoryViewModel.swift
├── Services/
│   ├── ScreenCaptureService.swift
│   ├── HotKeyService.swift
│   ├── StorageService.swift
│   └── AnnotationRenderer.swift
├── Extensions/
│   ├── NSImage+Extensions.swift
│   ├── Color+Extensions.swift
│   └── CGImage+Extensions.swift
└── Assets.xcassets/
```

## Privacy

ScreenNote respects your privacy:
- All screenshots are stored locally on your Mac
- No data is sent to external servers
- Screen recording permission is only used for screenshot capture
- No analytics or tracking

## License

MIT License - see [LICENSE](LICENSE) file for details

## Support

For issues, feature requests, or questions:
- Open an issue on GitHub
- Email: support@lopodragon.com

## Roadmap

- [ ] Custom hotkey configuration
- [ ] Multiple annotation layers
- [ ] Export to PDF
- [ ] Cloud sync (iCloud)
- [ ] Video annotation support
- [ ] Batch processing

## Credits

Developed by LopodragonDev
Copyright © 2026 LopodragonDev. All rights reserved.

---

Made with ❤️ for macOS
