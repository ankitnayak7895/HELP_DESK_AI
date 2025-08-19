#!/bin/bash

# Exit if any command fails
set -e

echo "🚀 Initializing Smart Helpdesk Project..."

# Project root
mkdir -p smart-helpdesk/backend/app
mkdir -p smart-helpdesk/backend/tests

# Navigate to backend
cd smart-helpdesk/backend

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install fastapi uvicorn[standard] sqlalchemy pydantic bcrypt passlib python-jose

# Freeze dependencies to requirements.txt
pip freeze > requirements.txt

# Create app files
cd app
touch __init__.py main.py database.py models.py schemas.py auth.py tickets.py agent.py kb.py audit.py

# Create test files
cd ../tests
touch __init__.py test_auth.py test_tickets.py test_agent.py

# Back to backend root
cd ..

# Create Dockerfile
cat <<EOF > Dockerfile
FROM python:3.10-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY ./app ./app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
EOF

# Create docker-compose.yml at project root
cd ..
cat <<EOF > docker-compose.yml
version: "3.9"
services:
  api:
    build: ./backend
    ports:
      - "8000:8000"
    volumes:
      - ./backend:/app
    environment:
      - PYTHONUNBUFFERED=1
EOF

# Create README.md
cat <<EOF > README.md
# Smart Helpdesk with Agentic Triage

## Setup
\`\`\`bash
./init_setup.sh
docker compose up --build
\`\`\`

Then open: http://localhost:8000/docs
EOF

echo "✅ Project initialized successfully!"
