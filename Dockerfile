# ---------- Build stage ----------
FROM python:3.12-slim AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --user --no-cache-dir -r requirements.txt

# ---------- Runtime stage ----------
FROM python:3.12-slim

WORKDIR /app

# Create non-root user
RUN useradd -m -u 1000 appuser

# Copy only necessary files from builder
COPY --from=builder /root/.local /home/appuser/.local
COPY . .

# Make sure scripts in .local are usable
ENV PATH=/home/appuser/.local/bin:$PATH

# Change ownership
RUN chown -R appuser:appuser /app

USER appuser

# Expose the port your app runs on (change if needed)
EXPOSE 8000

# Change this according to your application
# Example for FastAPI:
# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

# Example for Flask:
# CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]

# Generic example (adjust to your entrypoint)
CMD ["python", "app.py"]
