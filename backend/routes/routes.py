from flask import send_from_directory, jsonify, render_template
import os
import sys

# Add the parent directory to sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))

from backend import app

@app.route('/')
def index():
    try:
        return send_from_directory(os.path.join(app.root_path, 'static'), 'index.html')
    except Exception as e:
        return f"Error: {str(e)}", 500

@app.route('/<path:path>')
def static_files(path):
    try:
        return send_from_directory(os.path.join(app.root_path, 'static'), path)
    except Exception as e:
        return f"Error: {str(e)}", 404

@app.route('/api', methods=['GET'])
def api():
    return jsonify({'message': 'Hello, World!'})