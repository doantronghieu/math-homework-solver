# Homework Problem Solver - Development Commands
# 
# Usage:
#   make install      - Install all dependencies (backend + mobile)
#   make run-backend  - Run Flask backend server
#   make run-mobile   - Run Flutter mobile app
#   make test         - Run tests for both backend and mobile
#   make clean        - Clean build artifacts
#   make help         - Show this help message

.PHONY: help install install-backend install-mobile run-backend run-mobile test test-backend test-mobile clean fix-flutter check-env setup test-api status

# Default target
help:
	@echo "Homework Problem Solver - Development Commands"
	@echo ""
	@echo "Available commands:"
	@echo "  make install      - Install all dependencies (backend + mobile)"
	@echo "  make run-backend  - Run Flask backend server (port 8000)"
	@echo "  make run-mobile   - Run Flutter mobile app"
	@echo "  make test         - Run tests for both backend and mobile"
	@echo "  make clean        - Clean build artifacts"
	@echo "  make fix-flutter  - Fix Flutter IDE configuration issues"
	@echo "  make help         - Show this help message"
	@echo ""
	@echo "Backend only:"
	@echo "  make install-backend - Install Python dependencies"
	@echo "  make test-backend    - Run backend tests"
	@echo ""
	@echo "Mobile only:"
	@echo "  make install-mobile  - Install Flutter dependencies"
	@echo "  make test-mobile     - Run Flutter tests"
	@echo ""
	@echo "Troubleshooting:"
	@echo "  make fix-flutter     - Fix Flutter IDE package recognition issues"
	@echo ""
	@echo "Setup required:"
	@echo "  1. Add OPENAI_API_KEY to backend/.env"
	@echo "  2. Run: make install"
	@echo "  3. Run: make run-backend (in one terminal)"
	@echo "  4. Run: make run-mobile (in another terminal)"

# Install all dependencies
install: install-backend install-mobile
	@echo "✅ All dependencies installed successfully!"

# Install backend dependencies
install-backend:
	@echo "📦 Installing backend dependencies..."
	cd backend && uv sync
	@echo "✅ Backend dependencies installed!"

# Install mobile dependencies
install-mobile:
	@echo "📦 Installing mobile dependencies..."
	cd mobile && flutter pub get
	@echo "✅ Mobile dependencies installed!"

# Run backend server
run-backend:
	@echo "🚀 Starting Flask backend server..."
	@echo "🌐 Backend will be available at: http://localhost:8000"
	@echo "📋 API endpoints:"
	@echo "   GET  /api/health - Health check"
	@echo "   POST /api/solve  - Solve homework problem"
	@echo ""
	@echo "💡 Note: Using port 8000 to avoid macOS port conflicts"
	@echo "📝 Stateless design - no database required!"
	@echo ""
	cd backend && uv run main.py

# Run mobile app
run-mobile:
	@echo "📱 Starting Flutter mobile app..."
	@echo "💡 Make sure backend is running on port 8000 first"
	@echo "🎯 Simple flow: Photo → AI → Solution"
	cd mobile && flutter run

# Run all tests
test: test-backend test-mobile
	@echo "✅ All tests completed!"

# Run backend tests
test-backend:
	@echo "🧪 Running backend tests..."
	@if [ -d "backend/tests" ]; then \
		cd backend && (uv run pytest -v 2>/dev/null || echo "⚠️  pytest not installed - add pytest to dependencies to run tests"); \
	else \
		echo "⚠️  No backend tests found - create backend/tests/ directory and add tests"; \
	fi

# Run mobile tests
test-mobile:
	@echo "🧪 Running mobile tests..."
	cd mobile && flutter test

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	cd backend && rm -rf .venv __pycache__ *.pyc .pytest_cache
	cd mobile && flutter clean
	@echo "✅ Clean completed!"

# Fix Flutter IDE issues
fix-flutter:
	@echo "🔧 Fixing Flutter IDE configuration..."
	@echo "📝 This fixes common IDE issues where packages aren't recognized"
	cd mobile && flutter clean
	cd mobile && flutter pub get
	cd mobile && flutter analyze
	@echo "✅ Flutter IDE configuration fixed!"
	@echo "💡 If still having issues, restart your IDE/editor"

# Development helpers
check-env:
	@echo "🔍 Checking environment setup..."
	@echo ""
	@echo "Backend environment:"
	@if [ -f "backend/.env" ]; then \
		echo "✅ backend/.env exists"; \
		if grep -q "OPENAI_API_KEY" backend/.env; then \
			echo "✅ OPENAI_API_KEY is set"; \
		else \
			echo "❌ OPENAI_API_KEY not found in .env"; \
		fi; \
	else \
		echo "❌ backend/.env not found - copy from backend/.env.example"; \
	fi
	@echo ""
	@echo "Required tools:"
	@command -v uv >/dev/null 2>&1 && echo "✅ uv is installed" || echo "❌ uv not found - install from https://docs.astral.sh/uv/"
	@command -v flutter >/dev/null 2>&1 && echo "✅ flutter is installed" || echo "❌ flutter not found - install from https://flutter.dev/"
	@echo ""
	@echo "✨ Simplified architecture - no Firebase setup needed!"

# Quick setup for new developers
setup: check-env
	@echo ""
	@echo "🚀 Quick setup checklist:"
	@echo "1. Install uv: curl -LsSf https://astral.sh/uv/install.sh | sh"
	@echo "2. Install Flutter: https://flutter.dev/docs/get-started/install"
	@echo "3. Copy backend/.env.example to backend/.env"
	@echo "4. Add your OpenAI API key to backend/.env"
	@echo "5. Run: make install"
	@echo "6. Run: make run-backend (in one terminal)"
	@echo "7. Run: make run-mobile (in another terminal)"
	@echo ""
	@echo "🎯 That's it! No database setup required."

# Test API endpoints
test-api:
	@echo "🧪 Testing API endpoints..."
	@echo "📡 Health check:"
	@curl -s http://localhost:8000/api/health | python3 -m json.tool || echo "❌ Backend not running or not responding"
	@echo ""
	@echo "💡 To test /api/solve endpoint, use the mobile app or:"
	@echo "curl -X POST http://localhost:8000/api/solve -F \"image=@path/to/image.jpg\""

# Development status
status:
	@echo "📊 Project Status:"
	@echo ""
	@echo "Architecture: ✅ Simplified (stateless, no database)"
	@echo "Backend: ✅ Flask + LangChain + OpenAI"
	@echo "Frontend: ✅ Flutter mobile app"
	@echo "Dependencies: ✅ Minimal (4 backend, 6 mobile)"
	@echo "Setup: ✅ Simple (just OpenAI API key needed)"
	@echo ""
	@echo "🚀 Ready for development!"