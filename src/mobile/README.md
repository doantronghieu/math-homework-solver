# Homework Solver Mobile App

A Flutter mobile app that captures homework problem images and sends them to an AI backend for step-by-step solutions.

## Features

- 📸 Camera and gallery image capture
- 🤖 AI-powered problem solving
- 📚 Markdown-rendered solutions with math symbols
- 📱 Clean, responsive UI design
- ⚡ Real-time solution display

## Architecture

- **Framework**: Flutter with Material Design
- **Image Handling**: image_picker for camera/gallery access
- **API Communication**: HTTP requests to Flask backend
- **Solution Display**: flutter_markdown with LaTeX-to-Unicode conversion
- **State Management**: Simple StatefulWidget pattern

## File Structure

```
lib/
├── main.dart                    # App entry point
├── screens/
│   └── homework_solver_screen.dart  # Main UI screen
└── services/
    └── api_service.dart         # Backend API communication
```

## Dependencies

- `flutter` - UI framework
- `image_picker` - Camera/gallery access
- `http` - API communication
- `flutter_markdown` - Solution rendering
- `markdown` - Markdown parsing

## Setup

1. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

2. **Configure backend URL:**
   Edit `lib/services/api_service.dart` and update `baseUrl`:
   - iOS simulator: `http://localhost:8000/api`
   - Android emulator: `http://10.0.2.2:8000/api`
   - Real device: `http://YOUR_IP:8000/api`

3. **Run the app:**
   ```bash
   flutter run
   ```

## Key Components

### ApiService
- Handles HTTP communication with Flask backend
- Health checks and problem solving requests
- Error handling and timeout management

### HomeworkSolverScreen
- Main UI with image capture and solution display
- Camera/gallery integration via image_picker
- Markdown rendering with math symbol conversion
- Loading states and error handling

### Math Text Processing
The app automatically converts LaTeX expressions to readable Unicode:
- `\times` → `×`
- `\div` → `÷`
- `\text{Value}` → `Value`
- And many more mathematical symbols

## Usage Flow

1. App launches and checks backend health
2. User taps "Add Photo" to capture/select image
3. User taps "Solve" to send image to AI
4. Solution appears with proper math formatting
5. User can select/copy solution text

## Development

- Run `flutter analyze` to check for issues
- Run `flutter test` to run unit tests
- Use `flutter clean` to reset build cache
- Backend must be running on port 8000 for API calls