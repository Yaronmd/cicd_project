# Use a Python base image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy your tests into the container
COPY tests/ /app/tests/

# Set the default command to run pytest
CMD ["pytest", "tests"]
