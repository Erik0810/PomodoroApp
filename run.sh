#!/bin/bash

echo "Setting up development environment..."

# Create static directory if it doesn't exist
mkdir -p backend/static

# Build the Vue frontend
echo "Building Vue frontend..."
cd frontend
npm install
npm run build

# Check if build was successful and dist directory exists
if [ -d "dist" ] && [ "$(ls -A dist)" ]; then
    echo "Vue build successful, copying files..."
    # Copy built files to the backend static folder
    mkdir -p ../backend/static
    cp -r dist/* ../backend/static/
else
    echo "Vue build failed or dist directory not created. Creating a simple index.html..."
    # Create a simple index.html in the backend/static directory
    mkdir -p ../backend/static
    echo '<!DOCTYPE html>
    <html>
    <head>
        <title>Pomodoro App</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                text-align: center;
                margin-top: 50px;
            }
            button {
                background-color: #4CAF50;
                border: none;
                color: white;
                padding: 15px 32px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
                font-size: 16px;
                margin: 4px 2px;
                cursor: pointer;
                border-radius: 4px;
            }
            button:hover {
                background-color: #45a049;
            }
        </style>
    </head>
    <body>
        <h1>Pomodoro</h1>
        <button onclick="fetchMessage()">Get Message from Server</button>
        <p id="message"></p>
        <script>
            function fetchMessage() {
                fetch("/api")
                    .then(response => response.json())
                    .then(data => {
                        document.getElementById("message").textContent = data.message;
                    })
                    .catch(error => {
                        console.error("Error:", error);
                        document.getElementById("message").textContent = "Error connecting to server";
                    });
            }
        </script>
    </body>
    </html>' > ../backend/static/index.html
fi

# Go back to the project root directory
cd ..

# Start the Flask app
echo "Starting Flask app..."
cd backend
python app.py