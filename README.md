# Flutter WhiteBoard

An interactive whiteboard built with Flutter for sketching, annotating, and arranging visual content with shape tools, freehand drawing, text, and image placement.

## Overview

Flutter WhiteBoard provides a canvas-based editor where you can:

- Draw rectangles, circles, lines, and freehand brush strokes
- Add editable text blocks with font/alignment controls
- Import images and place them on the canvas
- Move, resize, rotate, duplicate, delete, and reorder elements
- Zoom in/out and pan across the canvas
- Undo/redo edits
- Export the canvas to PNG or JPEG (web download flow)

## Features

### Drawing tools

- Rectangle
- Circle
- Line/Arrow path
- Grab/Select
- Text
- Brush
- Eraser
- Image picker
- Delete tool

### Styling controls

- Stroke color (preset + custom picker)
- Fill/background color (preset + custom picker)
- Opacity
- Stroke width
- Stroke style (solid/dashed)
- Text color
- Font family (CommicSans, LilitaOne, Nunito)
- Font size (S, M, L, XL)
- Text alignment (left, center, right)
- Layer ordering (up/down/top/bottom)

### Canvas actions

- Pan canvas by dragging empty space when no tool is active
- Zoom controls with percentage indicator
- Undo / Redo
- Export PNG / JPEG

## Tech Stack

- Flutter
- flutter_bloc (text state updates)
- screenshot (canvas capture)
- image_picker (image import)
- flex_color_picker (color selection)
- dotted_border, touchable, arrow_path (shape rendering/interaction)

## Project Structure

```text
lib/
  Core/
    Constants/         # enums, colors, sizing tokens
    Enitity/           # shape models + undo stack model
    CustomClipper/     # custom painters for line/brush
    DeviceUtils/       # screen/device helpers
    HelpingFunctions/  # utility helpers (image picker, paths, etc.)
  Feature/
    MainPage/
      Controller/      # canvas behavior, tool logic, undo/redo, export
      Domain/Entities/ # toolbar item entities
      Presentation/    # UI widgets + text bloc
  main.dart            # app entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (Dart SDK compatible with `>=3.4.4 <4.0.0`)
- A device/emulator/browser target configured for Flutter

### Installation

```bash
flutter pub get
```

### Run

```bash
flutter run
```

Run on web explicitly:

```bash
flutter run -d chrome
```

## Usage Guide

1. Select a tool from the bottom toolbar.
2. Draw or place content on the canvas.
3. Select an element (or Grab tool) to adjust its properties.
4. Use the left side panel for styling and layer controls.
5. Use zoom and undo/redo controls at the bottom.
6. Open the drawer to export PNG/JPEG.

## Keyboard Interactions

When a shape is selected:

- `D`: duplicate selected item
- `←` / `→`: rotate selected item in small increments
- `Shift + ←` / `Shift + →`: rotate in larger increments
- `↑` / `↓`: move selected item
- `Shift + ↑` / `Shift + ↓`: move selected item faster
- `Enter` on selected text: switch text into edit mode

## Build, Analyze, and Test

```bash
flutter analyze
flutter test
```

> Note: The default `test/widget_test.dart` is the template counter test and does not currently reflect this whiteboard app's UI behavior.

## Known Notes

- Export saving is implemented for web downloads; native platform save flow is currently stubbed in controller code.
- This project is not configured for publishing (`publish_to: 'none'`).

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes and validate with `flutter analyze` and `flutter test`
4. Open a pull request

## License

No license file is currently defined in this repository.
