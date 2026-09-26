# ---------- Build stage ----------
FROM python:3.12-slim AS builder

WORKDIR /app

# Install only the necessary build tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc && \
    rm -rf /var/lib/apt/lists/*

# Copy only requirements first (better caching)
COPY requirements.txt .

# Install dependencies into a virtual environment
RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# ---------- Runtime stage ----------
FROM python:3.12-slim

WORKDIR /app

# Create non-root user
RUN useradd --create-home --uid 1000 appuser

# Copy the virtual environment from builder
COPY --from=builder /opt/venv /opt/venv

# Copy only the application code (avoid copying unnecessary files)
COPY --chown=appuser:appuser app.py .
# Add more COPY lines if you have other folders/files needed at runtime
# COPY --chown=appuser:appuser ./your_package ./your_package

# Use the virtual environment
ENV PATH="/opt/venv/bin:$PATH"

USER appuser

EXPOSE 8000

# Change this according to your application
CMD ["python", "app.py"]

# Examples:
# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
# CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
