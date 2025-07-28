import os
from dotenv import load_dotenv
from flask import Flask, request, jsonify
from flask_cors import CORS

from services.homework_solver import HomeworkSolver

# Load environment variables
load_dotenv()

# Initialize Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS for mobile app communication

# Initialize homework solver service
homework_solver = HomeworkSolver()


@app.route('/api/health', methods=['GET'])
def health_check():
    """Health check endpoint."""
    return jsonify({
        'status': 'healthy',
        'service': 'Homework Problem Solver API',
        'version': '1.0.0'
    })


@app.route('/api/solve', methods=['POST'])
def solve_problem():
    """Solve a homework problem from uploaded image."""
    try:
        # Check if image file is provided
        if 'image' not in request.files:
            return jsonify({
                'success': False,
                'error': 'No image file provided'
            }), 400
        
        image_file = request.files['image']
        if image_file.filename == '':
            return jsonify({
                'success': False,
                'error': 'No image file selected'
            }), 400
        
        # Read image data
        image_data = image_file.read()
        
        # Solve the homework problem
        result = homework_solver.solve_homework_problem(image_data)
        
        if result['success']:
            return jsonify(result)
        else:
            return jsonify(result), 500
            
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500


def main():
    """Run the Flask development server."""
    app.run(
        host='0.0.0.0',
        port=int(os.getenv('PORT', 8000)),  # Port 8000 to avoid conflicts
        debug=os.getenv('FLASK_DEBUG', 'False').lower() == 'true'
    )


if __name__ == "__main__":
    main()