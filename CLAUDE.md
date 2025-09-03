# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Qt6 QML application project called `qrc_test` that implements a Discord-like chat interface with multiple pages (Message, Server, Marketplace, Setting). The application uses Qt6 Quick with QML for the UI and minimal C++ for the main entry point.

## Architecture

### Core Structure
- **Main.qml**: Root application window with navigation wheel and page loader system
- **main.cpp**: Minimal Qt application entry point that loads the Main QML module
- **CMakeLists.txt**: CMake build configuration with Qt6 Quick dependencies

### Page System
The application uses a component-based architecture with a central Loader that switches between pages:
- `Message_page_q.qml` - Friends chat interface
- `Server_page_q.qml` - Server management and chat
- `Marketplace_page_q.qml` - Marketplace interface  
- `Setting_page_q.qml` - Application settings

### Component Organization
- **Server_component/**: Server-related UI components including server lists, chat blocks, member lists, and function blocks
- **Message_component/**: Friends chat list components
- **Setting_page_component/**: Settings interface components
- **Style_component/**: Reusable style components (referenced in build but not present in source tree)

### Resource Management
- Images stored in `img/` directory (backgrounds, avatars)
- SVG icons in `svg_icon/` directory
- Resources managed through `resources.qrc` and CMake resource configuration
- Build generates resource compilation in Qt's resource system

## Development Commands

### Build
```bash
# Configure and build (from project root)
mkdir -p build/Qt_6_9_1_for_macOS-Debug
cd build/Qt_6_9_1_for_macOS-Debug
cmake ../..
cmake --build .

# Run the application
./appqrc_test.app/Contents/MacOS/appqrc_test
```

### Project Structure Notes
- QML module URI: `qrc_test`
- Executable name: `appqrc_test`
- Qt6 minimum version: 6.8 required, 6.9.1 currently used
- Build directory follows Qt Creator convention: `build/Qt_6_9_1_for_macOS-Debug/`

## Development Patterns

### QML Module System
The project uses Qt6's modern QML module system with `qt_add_qml_module()` in CMake. All QML files and resources are explicitly declared in the CMakeLists.txt.

### Navigation Pattern
Navigation uses a picker wheel component (`Nav_wheel.qml`) that drives a Loader component to switch between page components dynamically.

### Resource Pattern
Resources (images, icons) are managed through both CMake resource declarations and a traditional .qrc file, providing flexibility for resource access patterns.