# Changelog

All notable changes to ScreenNote will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-25

### Added
- Initial release of ScreenNote
- Global hotkey (Cmd+Shift+A) for instant screen capture
- Region selection for screenshots
- Comprehensive annotation tools:
  - Arrow annotations
  - Text labels
  - Highlight areas
  - Blur/pixelate regions
  - Rectangle shapes
  - Circle shapes
  - Numbered circles for step-by-step annotations
  - Freehand drawing
- Color picker for customizing annotation colors
- Undo functionality for annotations
- Quick actions:
  - Copy to clipboard
  - Save to Desktop
  - Share via macOS share sheet
- Menu bar app integration
- Screenshot history panel with:
  - Thumbnail previews
  - Timestamp information
  - Quick actions (view, copy, share, delete)
- Dark mode support
- Screen recording permission handling
- Local storage for screenshots and history
- MVVM architecture with SwiftUI + AppKit
- Core Graphics rendering for annotations
- Zero external dependencies

### Technical Details
- Minimum macOS version: 14.0
- Bundle ID: com.lopodragon.screennote
- App Store Category: Productivity
- Price: $3.99 USD (one-time purchase)
- Code signing with hardened runtime
- Sandbox enabled for App Store compliance

---

For future updates, check this file or visit the GitHub repository.
