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

**Status**: Production-ready

**Features**:
- Plain text extraction from PDF documents
- Intelligent blank page detection using ROI-based variance analysis
- OpenAI-compatible API endpoints (`/v1/chat/completions`)
- GPU acceleration with NVIDIA L4 (24GB VRAM)
- Multi-page document processing
- 109 languages support via PaddleOCR-VL model

**Technical Stack**:
- Inference: Transformers-based approach with `AutoModelForCausalLM`
- Framework: PyTorch 2.3.0 with CUDA 12.1
- Deployment: Google Cloud Run with GPU support

---

### v0.7.0 (In Development) 🚧

**Focus**: Structured markdown output with layout detection

**Key Features**:
- **Structured Markdown Output**: Proper formatting with headings (`#`, `##`), tables (`|`), lists, and emphasis (`**`, `*`)
- **Document Pre-processing Pipeline**:
  - Orientation classification (0°, 90°, 180°, 270° detection and correction)
  - Document unwarping (1-5° rotation correction and perspective distortion removal)
- **Layout Detection**: PP-DocLayoutV2 with RT-DETR for accurate document structure recognition
- **Enhanced Table Recognition**: Markdown table format with proper cell alignment
- **Reading Order Intelligence**: Correct element sequencing (top-to-bottom, left-to-right)

**Technical Changes**:
- Migration from PyTorch/Transformers to PaddlePaddle ecosystem
- Official PaddleOCR pipeline integration with `PaddleOCRVL` class
- Multi-stage processing: orientation → unwarping → layout detection → element recognition
- CUDA 12.6 support for PaddlePaddle 3.2.0

**Expected Performance**:
- Processing speed: ~0.8-1.0 pages/second on L4 GPU
- Memory efficiency: ~40% reduction compared to v0.6.0
- Layout accuracy: 95%+ with pre-processing pipeline

---

### v0.8.0 (Planned) 📐

**Focus**: Element extraction and spatial analysis

**Planned Features**:
- **Element Cropping**: Extract individual document elements (text blocks, tables, figures) as separate images
- **Image Extraction**: Save embedded images, charts, and diagrams from documents
- **Bounding Box Detection**: Precise spatial coordinates for all detected elements
- **Element Classification**: Automatic categorization (heading, paragraph, table, figure, formula)
- **Spatial Relationships**: Preserve relative positioning information

**Use Cases**:
- Document segmentation for downstream processing
- Training data generation for ML models
- Fine-grained document analysis
- Custom layout reconstruction

---

### v0.9.0 (Planned) 📋

**Focus**: DOCX generation with formatting preservation

**Planned Features**:
- **DOCX Generation**: Direct conversion from PDF to Microsoft Word format
- **Image Embedding**: Automatic insertion of extracted images in correct positions
- **Advanced Formatting**:
  - Font styles and sizes preservation
  - Paragraph spacing and alignment
  - Table borders and cell formatting
  - Header and footer detection
- **Multi-column Layout**: Support for complex document structures
- **Metadata Preservation**: Document properties, author information, creation date

**Technical Approach**:
- Integration with `python-docx` library
- Layout-to-DOCX mapping engine
- Style inference from visual elements
- Template-based formatting

---

### v1.0.0 (Stable Release) 🎯

**Focus**: Production-ready release with comprehensive features

**Objectives**:
- **Feature Complete**: All planned features from v0.6-v0.9 fully implemented and tested
- **Performance Optimized**:
  - Batch processing support for high-throughput scenarios
  - Memory optimization for large documents (100+ pages)
  - Inference acceleration with vLLM or SGLang backends
- **Production Hardening**:
  - Comprehensive error handling and recovery
  - Extensive logging and monitoring
  - Rate limiting and resource management
- **Documentation**:
  - Complete API reference
  - Integration guides for common frameworks
  - Performance tuning recommendations
  - Troubleshooting guides
- **Testing**:
  - 90%+ code coverage
  - Integration tests for all endpoints
  - Performance benchmarks across document types
  - Stress testing for concurrent requests

**Quality Metrics**:
- Uptime: 99.9% SLA
- Processing accuracy: 98%+ for standard documents
- API response time: < 5s for typical documents
- Support for 109 languages with consistent quality

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
