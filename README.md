# PaddleOCR-VL API - Google Cloud Run

High-performance OCR API based on PaddleOCR-VL, deployed on Google Cloud Run with NVIDIA L4 GPU.

**Current Version (v0.6.0)**: Text extraction from PDFs with intelligent blank page detection.

## ✨ Features

- 🚀 **GPU-Accelerated OCR**: NVIDIA L4 GPU (24GB VRAM) for fast inference
- 🧠 **Intelligent Blank Page Detection**: ROI-based variance analysis reduces processing time
- 🌍 **Multilingual Support**: 109 languages supported by PaddleOCR-VL
- 📄 **Text Extraction**: Extracts text from PDFs, tables, formulas, and charts
- 🔌 **OpenAI-Compatible API**: Drop-in replacement for OpenAI endpoints
- 📊 **Detailed Statistics**: Per-page processing metrics and confidence scores
- 🐳 **Production-Ready**: Docker container optimized for Cloud Run
- 📝 **Plain Text Output**: Clean text extraction (v0.6.0)

## 🚀 Quick Start

### Prerequisites

- Google Cloud Platform account
- gcloud CLI installed and configured
- Docker (for local testing)

### Deployment

```bash
# Clone repository
git clone https://github.com/Edito-Omissis/paddleocr-vl-gcp-cloudrun.git
cd paddleocr-vl-gcp-cloudrun

# Configure GCP project
export GCP_PROJECT_ID=your-project-id

# Deploy to Cloud Run (run from project root)
bash scripts/deployment/deploy.sh
```

### Local Testing

```bash
# Run locally with Docker
cd scripts/testing
./run_local.sh

# Test with sample PDF
python3 test_local.py path/to/your/document.pdf
```

## 📚 Documentation

- **[CHANGELOG](CHANGELOG.md)** - Version history and changes
- **[NAVIGATION](NAVIGATION.md)** - Quick navigation guide

### Code Documentation

All code is fully documented with English comments:
- [server.py](server.py) - FastAPI server with comprehensive docstrings
- [pdf_processor.py](pdf_processor.py) - PDF processing with ROI-based blank page detection
- [deploy.sh](scripts/deployment/deploy.sh) - Deployment script with step-by-step comments

## 🏗️ Architecture

### Components

- **FastAPI Server** (`server.py`): REST API with OpenAI-compatible endpoints
- **PDF Processor** (`pdf_processor.py`): PDF to image conversion with intelligent filtering
- **PaddleOCR-VL Model**: 0.9B parameter vision-language model for document understanding

### Blank Page Detection Algorithm

The ROI-based variance analysis algorithm:
1. Divides page into 64x64 pixel tiles
2. Calculates pixel variance for each tile
3. High variance = content (text, graphics)
4. Low variance = blank/uniform
5. Skips pages with < 5 informative tiles

**Result**: Significant reduction in processing time and costs (varies by document)

### Resource Configuration

- **CPU**: 4 vCPU (sufficient, GPU is bottleneck)
- **Memory**: 16GB RAM (handles 10 concurrent requests)
- **GPU**: 1x NVIDIA L4 (24GB VRAM, model uses ~4GB)
- **Concurrency**: 10 requests per instance
- **Timeout**: 600 seconds (10 minutes)

## 🔌 API Endpoints

### POST /ocr

Direct OCR endpoint with file upload.

```bash
curl -X POST https://your-service.run.app/ocr \
  -F "file=@document.pdf" \
  -F "skip_blank=true"
```

**Response**:
```json
{
  "success": true,
  "pages_total": 16,
  "pages_processed": 11,
  "pages_skipped": 5,
  "skipped_pages": [2, 5, 8, 12, 15],
  "processed_pages": [1, 3, 4, 6, 7, 9, 10, 11, 13, 14, 16],
  "markdown": "<!-- Page 1 -->\n\nDocument Title\n\n...",
  "total_chars": 15234,
  "page_stats": [...]
}
```

### POST /v1/chat/completions

OpenAI-compatible endpoint with base64 PDF.

```bash
curl -X POST https://your-service.run.app/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "paddleocr-vl",
    "messages": [{
      "role": "user",
      "content": "data:application/pdf;base64,<BASE64_PDF>"
    }]
  }'
```

### GET /health

Health check endpoint.

```bash
curl https://your-service.run.app/health
```

## 🛠️ Development

### Project Structure

```
paddleocr-vl/
├── server.py              # FastAPI server
├── pdf_processor.py       # PDF processing
├── requirements.txt       # Python dependencies
├── Dockerfile            # Container definition
├── scripts/
│   ├── deployment/       # Deployment scripts
│   ├── testing/          # Test scripts
│   └── utilities/        # Utility scripts
└── tests/                # Test files and results
```

### Environment Variables

- `MODEL_ID`: HuggingFace model ID (default: `PaddlePaddle/PaddleOCR-VL`)
- `MAX_NEW_TOKENS`: Maximum generation length (default: `2048`)
- `PDF_DPI`: PDF rendering resolution (default: `200`)
- `PORT`: Server port (default: `8080`)

### Local Development

```bash
# Create virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run server
python3 server.py
```

## 📊 Performance

### Benchmarks

- **Cold start**: ~10 seconds
- **Processing speed**: ~2-3 seconds per page (with GPU)
- **Blank page detection**: < 100ms per page
- **Cost savings**: Significant reduction with blank page filtering (varies by document)

### Scaling

- **Auto-scaling**: 0-3 instances based on load
- **Concurrency**: 10 requests per instance
- **Max throughput**: ~30 concurrent requests

## 🗺️ Roadmap

### v0.6.0 (Current) ✅
- Plain text extraction from PDFs
- Intelligent blank page detection
- OpenAI-compatible API
- GPU acceleration with NVIDIA L4

### v0.7.0 (Next) 🚧
- **Structured Markdown Output**: Proper markdown formatting with headings, tables, lists
- **Layout Detection**: Automatic document structure recognition
- **Enhanced Table Recognition**: Markdown table format
- Migration to official PaddleOCR pipeline

### v0.8.0 (Planned) 📐
- **Element Cropping**: Extract and crop individual document elements
- **Image Extraction**: Save images from charts and figures
- **Bounding Box Detection**: Precise element positioning

### v0.9.0 (Planned) 📋
- **DOCX Generation**: Direct conversion to Microsoft Word format
- **Image Embedding**: Embed extracted images in DOCX
- **Advanced Formatting**: Preserve document styling and layout

### v1.0.0 (Stable Release) 🎯
- Production-ready with all features
- Performance optimizations
- Comprehensive documentation
- Full test coverage

## 🔒 License Compliance

All dependencies are GPL-free and suitable for commercial use:
- **pypdfium2**: Apache 2.0 (PDF rendering)
- **PaddleOCR-VL**: Apache 2.0 (OCR model)
- **FastAPI**: MIT (web framework)
- **PyTorch**: BSD (ML framework)

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes with tests
4. Submit a pull request

## 📝 Citation

If you use this project in your research, please cite:

```bibtex
@software{paddleocr_vl_api,
  title = {PaddleOCR-VL API for Google Cloud Run},
  author = {Your Name},
  year = {2025},
  url = {https://github.com/Edito-Omissis/paddleocr-vl-gcp-cloudrun}
}
```

## 🙏 Acknowledgments

- [PaddleOCR](https://github.com/PaddlePaddle/PaddleOCR) - OCR framework
- [PaddleOCR-VL](https://huggingface.co/PaddlePaddle/PaddleOCR-VL) - Vision-language model
- [Google Cloud Run](https://cloud.google.com/run) - Serverless platform

## 📧 Contact

For questions or support, please open an issue on GitHub.

---

**Version**: v0.6.0  
**Last Updated**: November 2025  
**Status**: Production Ready ✅
