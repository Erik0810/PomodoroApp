# Stage 1: Build the Vue frontend
FROM node:20.17.0 AS frontend-build
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# Stage 2: Set up the Flask backend and serve the Vue app
FROM python:3.12.9
WORKDIR /app/backend
COPY backend/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy the built frontend files to the Flask static directory
COPY --from=frontend-build /app/frontend/dist /app/backend/static

# Expose the port for the Flask app
EXPOSE 5000

# Command to run the Flask app with Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]