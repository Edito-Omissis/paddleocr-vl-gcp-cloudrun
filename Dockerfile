# Dockerfile ottimizzato per Google Cloud Run con GPU L4
# PaddleOCR-VL su CUDA 12.1 con vLLM/Transformers

FROM nvidia/cuda:12.1.0-devel-ubuntu22.04

# Evita interazioni durante l'installazione
ENV DEBIAN_FRONTEND=noninteractive

# Installa Python 3.10 e dipendenze di sistema
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    python3.10-venv \
    git \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

# Crea link simbolici per python
RUN ln -sf /usr/bin/python3.10 /usr/bin/python && \
    ln -sf /usr/bin/python3.10 /usr/bin/python3

# Aggiorna pip
RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel

# Installa PyTorch con CUDA 12.1 support (versione più recente)
RUN pip install --no-cache-dir \
    torch==2.3.0 \
    torchvision==0.18.0 \
    --index-url https://download.pytorch.org/whl/cu121

# Installa dipendenze per PaddleOCR-VL e serving
RUN pip install --no-cache-dir \
    transformers>=4.45.0 \
    accelerate>=0.25.0 \
    einops>=0.7.0 \
    sentencepiece>=0.1.99 \
    protobuf>=3.20.0 \
    pillow>=10.0.0 \
    fastapi>=0.104.0 \
    uvicorn[standard]>=0.24.0 \
    python-multipart>=0.0.6 \
    pydantic>=2.0.0 \
    pypdfium2>=4.26.0 \
    pdf2image>=1.16.3 \
    pikepdf>=8.10.0

# Workdir
WORKDIR /app

# Copia i file dell'applicazione
COPY server.py .
COPY pdf_processor.py .
COPY requirements.txt .

# Pre-download del modello (necessario per Cloud Run - evita timeout durante startup)
# Aumenta dimensione immagine di ~2GB ma elimina download runtime
RUN python3 -c "from transformers import AutoModelForCausalLM, AutoProcessor; \
    print('Downloading PaddleOCR-VL model...'); \
    AutoModelForCausalLM.from_pretrained('PaddlePaddle/PaddleOCR-VL', trust_remote_code=True); \
    AutoProcessor.from_pretrained('PaddlePaddle/PaddleOCR-VL', trust_remote_code=True); \
    print('Model downloaded successfully')"

# Cloud Run usa la variabile PORT
ENV PORT=8080

# Health check endpoint
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD python3 -c "import requests; requests.get('http://localhost:8080/health')"

# Avvia il server
CMD ["python3", "server.py"]
