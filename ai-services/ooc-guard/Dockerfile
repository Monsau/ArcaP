FROM python:3.12-slim

WORKDIR /app

# System deps for owlready2 / rdflib
RUN apt-get update && apt-get install -y --no-install-recommends \
    default-jre-headless \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install OOC-Guard from local wheel
COPY ooc_guard-0.1.0-py3-none-any.whl .
RUN pip install --no-cache-dir ooc_guard-0.1.0-py3-none-any.whl[all]

# Copy application
COPY app.py .

EXPOSE 8003

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8003"]
