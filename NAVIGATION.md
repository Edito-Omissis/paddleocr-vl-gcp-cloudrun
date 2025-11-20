# 🗺️ Quick Navigation - PaddleOCR-VL

## 🚀 Quick Actions

### Deploy to Cloud Run
```bash
# Run from project root
bash scripts/deployment/deploy.sh
```

### Test Locally
```bash
cd scripts/testing
./run_local.sh
```

### Verify Deployment
```bash
# Run from project root
bash scripts/deployment/VERIFICATION.sh
```

## 📚 Documentation

### Essential
- [README](README.md) - Project overview and quick start (English)
- [README_IT](README_IT.md) - Panoramica progetto (Italian)
- [CHANGELOG](CHANGELOG.md) - Version history v0.6.0 (English)
- [CHANGELOG_IT](CHANGELOG_IT.md) - Storia versioni v0.6.0 (Italian)
- [PROJECT_TREE](PROJECT_TREE.txt) - Project structure

### Code Documentation
All code is fully documented with English comments:
- [server.py](server.py) - FastAPI server with comprehensive docstrings
- [pdf_processor.py](pdf_processor.py) - PDF processing with ROI-based blank page detection
- [deploy.sh](scripts/deployment/deploy.sh) - Deployment script with step-by-step comments

## 🔧 Scripts

### Deployment
- [deploy.sh](scripts/deployment/deploy.sh) - Automatic Cloud Run deployment
- [setup.sh](scripts/deployment/setup.sh) - Initial GCP setup
- [VERIFICATION.sh](scripts/deployment/VERIFICATION.sh) - Deployment verification

### Testing
- [run_local.sh](scripts/testing/run_local.sh) - Run local server
- [test_local.py](scripts/testing/test_local.py) - Local test suite

### Utilities
- [examples.sh](scripts/utilities/examples.sh) - API usage examples

## 📁 Core Files

### Source Code
- [server.py](server.py) - FastAPI server with OpenAI-compatible endpoints
- [pdf_processor.py](pdf_processor.py) - PDF processing with ROI-based blank page filter
- [requirements.txt](requirements.txt) - Python dependencies
- [Dockerfile](Dockerfile) - Docker container definition

### Configuration
- [.env.example](.env.example) - Environment variables template
- [.dockerignore](.dockerignore) - Docker build exclusions
- [.gitignore](.gitignore) - Git exclusions

## 🧪 Test Files

### Samples
- [tests/samples/test_sample.pdf](tests/samples/test_sample.pdf) - Simple test PDF
- [tests/samples/wrapper.pdf](tests/samples/wrapper.pdf) - Real-world test PDF (16 pages)

### Results
- [tests/results/wrapper_ocr_output.md](tests/results/wrapper_ocr_output.md) - OCR output example
- [tests/results/](tests/results/) - Additional test results

## 🔗 Useful Links

### Production Service
- **Service URL**: https://paddleocr-vl-api-kyus437a3q-ew.a.run.app
- **Health Check**: https://paddleocr-vl-api-kyus437a3q-ew.a.run.app/health
- **API Docs**: https://paddleocr-vl-api-kyus437a3q-ew.a.run.app/docs

### GitHub Repository
- **Repository**: https://github.com/Edito-Omissis/paddleocr-vl-gcp-cloudrun
- **Issues**: https://github.com/Edito-Omissis/paddleocr-vl-gcp-cloudrun/issues
- **Releases**: https://github.com/Edito-Omissis/paddleocr-vl-gcp-cloudrun/releases

### External Documentation
- **PaddleOCR-VL Model**: https://huggingface.co/PaddlePaddle/PaddleOCR-VL
- **Cloud Run GPU Docs**: https://cloud.google.com/run/docs/configuring/services/gpu
- **FastAPI Docs**: https://fastapi.tiangolo.com/

## 🎯 Current Status

- ✅ **Version**: v0.6.0 (First Public Release)
- ✅ **Service**: Production Ready on Cloud Run
- ✅ **OCR**: Accurate and fast with GPU L4
- ✅ **Blank Page Filter**: Active (reduces costs by skipping blank pages)
- ✅ **API**: OpenAI-compatible endpoints
- ✅ **Documentation**: Complete in English

---

**Last Updated**: November 20, 2025  
**Version**: v0.6.0  
**Maintained by**: Edito Omissis Development Team  
**License**: Apache 2.0  

**Note**: v1.0.0 will be released when DOCX generation feature is included
