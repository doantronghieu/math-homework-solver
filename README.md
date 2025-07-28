# Homework Problem Solver

A simple Flutter mobile app with Flask backend that uses AI to solve homework problems from images.

## Features

- 📸 Take photos or upload images of homework problems
- 🤖 AI-powered problem solving using GPT-4.1-nano
- 📚 Step-by-step solution explanations with proper math rendering
- 📱 Clean, intuitive Flutter mobile interface

## Architecture

- **Frontend**: Flutter mobile app with camera/gallery integration
- **Backend**: Flask API with LLM integration
- **AI**: OpenAI GPT-4.1-nano for image analysis and problem solving

## Project Structure

```
src/
├── backend/                 # Flask API server
│   ├── services/           
│   │   ├── llm/            # LLM integration (models, messages)
│   │   └── homework_solver.py  # Main business logic
│   ├── main.py             # Flask app and API endpoints
│   └── pyproject.toml      # Python dependencies
├── mobile/                 # Flutter mobile app
│   ├── lib/
│   │   ├── services/       # API service for backend communication
│   │   ├── screens/        # UI screens
│   │   └── main.dart       # App entry point
│   └── pubspec.yaml        # Flutter dependencies
└── Makefile                # Development commands
```

## Quick Start

### Prerequisites
- [uv](https://docs.astral.sh/uv/) for Python dependency management
- [Flutter](https://flutter.dev/docs/get-started/install) for mobile development
- OpenAI API key

### Setup Commands

```bash
# Navigate to project directory
cd src

# Check environment and show setup instructions
make setup

# Install all dependencies (backend + mobile)
make install

# Verify environment configuration
make check-env
```

### Development Workflow

```bash
# Terminal 1: Start backend server
make run-backend    # Runs on http://localhost:8000

# Terminal 2: Start mobile app
make run-mobile

# Run tests
make test
```

### Available Make Commands

- `make help` - Show all available commands
- `make install` - Install all dependencies (backend + mobile)
- `make run-backend` - Run Flask backend server (port 8000)
- `make run-mobile` - Run Flutter mobile app
- `make test` - Run tests for both backend and mobile
- `make clean` - Clean build artifacts
- `make check-env` - Verify environment setup
- `make setup` - Show setup checklist for new developers

## Manual Setup Instructions

### Backend Setup

1. **Install dependencies:**
   ```bash
   cd src/backend
   uv sync
   ```

2. **Set up environment variables:**
   ```bash
   cp .env.example .env
   # Edit .env file with your OpenAI API key:
   # OPENAI_API_KEY=your_openai_api_key
   ```

3. **Run the Flask server:**
   ```bash
   uv run main.py
   ```
   Server will run on http://localhost:8000

### Mobile Setup

1. **Install Flutter dependencies:**
   ```bash
   cd src/mobile
   flutter pub get
   ```

2. **Update API base URL (if needed):**
   - Edit `lib/services/api_service.dart`
   - Update `baseUrl` constant:
     - Android emulator: `http://10.0.2.2:8000/api`
     - iOS simulator: `http://localhost:8000/api`
     - Real device: `http://YOUR_COMPUTER_IP:8000/api`

3. **Run the Flutter app:**
   ```bash
   flutter run
   ```

## API Endpoints

- `GET /api/health` - Health check
- `POST /api/solve` - Solve homework problem (multipart form with image)

### Testing API Endpoints

```bash
# Health check
curl http://localhost:8000/api/health

# Upload and solve problem (replace with actual image file)
curl -X POST http://localhost:8000/api/solve \
  -F "image=@/path/to/homework-image.jpg"
```

## Usage Flow

1. **Launch the app** - Checks server health
2. **Take/select photo** - Capture homework problem image
3. **Solve problem** - Send to AI for analysis
4. **View solution** - Get step-by-step explanation with proper math rendering

## Dependencies

### Backend (Minimal)
- Flask (web framework)
- Flask-CORS (cross-origin requests)
- LangChain + OpenAI (LLM integration)
- python-dotenv (environment variables)

### Mobile
- Flutter (UI framework)
- image_picker (photo capture)
- http (API communication)
- flutter_markdown (solution rendering)

## Environment Variables

Create a `.env` file in the backend directory:

```env
# OpenAI Configuration (Required)
OPENAI_API_KEY=your_openai_api_key_here

# Optional: Custom port (default: 8000)
PORT=8000

# Optional: Flask debug mode
FLASK_DEBUG=True
```

## Development Notes

- **Simple Architecture**: Direct image → AI → response flow
- **Math Rendering**: LaTeX expressions converted to readable Unicode symbols
- **Port 8000**: Default port to avoid macOS AirPlay conflicts

## Troubleshooting

### Port 8000 Conflicts
- **Problem**: Port 8000 is already in use
- **Solution**: Set `PORT=8001` in `.env` file and update mobile app baseUrl

### OpenAI API Issues
- **Problem**: "OpenAI API key not found"
- **Solution**: Run `make check-env` to verify setup
- **Steps**: Add `OPENAI_API_KEY=your_key` to backend/.env

### Flutter Dependencies
- **Problem**: Package version conflicts
- **Solution**: Run `flutter pub upgrade --major-versions`
- **Alternative**: Use `make clean` then `make install`

### Math Rendering Issues
- **Problem**: LaTeX expressions not displaying properly
- **Solution**: App automatically converts LaTeX to Unicode symbols (× ÷ ≤ ≥ π)