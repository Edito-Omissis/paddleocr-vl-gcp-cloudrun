# 📝 Changelog - PaddleOCR-VL API

All notable changes to this project will be documented in this file.

## [v0.6.0] - 2025-11-20 ✅ FIRST PUBLIC RELEASE

### 🎉 Initial Release
This is the first public release of PaddleOCR-VL API for Google Cloud Run.

### 🎯 Features
- **PaddleOCR-VL Integration**: State-of-the-art vision-language model for document OCR
- **GPU Acceleration**: NVIDIA L4 GPU (24GB VRAM) on Google Cloud Run
- **Intelligent Blank Page Detection**: ROI-based variance analysis
  - 64×64 pixel tile analysis
  - Configurable threshold (variance > 100, min 5 tiles)
  - Automatically skips blank pages to avoid processing empty content
  - Reduces processing time and costs by filtering out blank pages
- **OpenAI-Compatible API**: Drop-in replacement for OpenAI endpoints
- **FastAPI Server**: Modern async Python web framework
- **PDF Processing**: License-compliant with pypdfium2 (Apache 2.0)
- **Markdown Output**: Clean, structured text output
- **Detailed Statistics**: Per-page processing metrics

### 🚀 Performance
- **Processing Speed**: ~2-3 seconds per page with GPU
- **Blank Page Detection**: < 100ms overhead per page
- **Cost Savings**: Significant reduction by skipping blank pages (varies by document)
- **Scalability**: Auto-scaling 0-3 instances, 10 concurrent requests per instance

### 📚 Documentation
- Complete English documentation
- Comprehensive code comments and docstrings
- Deployment guides for Google Cloud Run
- API usage examples
- Troubleshooting guide

### 🔧 Technical Stack
- **Model**: PaddlePaddle/PaddleOCR-VL (0.9B parameters)
- **Framework**: FastAPI + PyTorch
- **PDF Rendering**: pypdfium2 (Apache 2.0)
- **Container**: Docker with NVIDIA CUDA 12.1
- **Platform**: Google Cloud Run with GPU L4
- **Resources**: 4 vCPU, 16GB RAM, 1x GPU L4

### 🌍 Multilingual Support
- 109 languages supported by PaddleOCR-VL
- Text, tables, formulas, and charts recognition

---

## Future Roadmap

### v1.0.0 - Planned Release
**Target**: DOCX generation feature
- Convert OCR output to Microsoft Word format
- Preserve document structure and formatting
- Include images and tables

### Phase 2: Enhanced Document Understanding
- **PP-DocLayoutV2 integration**: Layout analysis with RT-DETR
- **Image extraction**: Detect and extract figures, charts, diagrams
- **DOCX output**: Generate Word documents with embedded images
- **Table recognition**: Native Word tables
- **Reading order**: Maintain document flow and structure

### Phase 3: Advanced Features
- **Batch processing**: Multiple PDFs in single request
- **Webhook support**: Async processing for large documents
- **Enhanced caching**: Avoid reprocessing identical documents
- **Quality metrics**: Confidence scores per element
- **Format options**: PDF, DOCX, HTML output

---

**Maintained by**: Edito Omissis Development Team  
**License**: Apache 2.0  
**Repository**: https://github.com/Edito-Omissis/paddleocr-vl-gcp-cloudrun
