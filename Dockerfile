FROM python:3.10-slim-bookworm

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt requirements-app.txt ./

RUN pip install --no-cache-dir -r requirements.txt -r requirements-app.txt

COPY . .

# Download only the matting model used by the mini program. Model weights are
# intentionally kept out of Git and baked into the image at build time.
RUN python3 scripts/download_model.py --models hivision_modnet

EXPOSE 8080

CMD ["python3", "-u", "deploy_api.py"]
