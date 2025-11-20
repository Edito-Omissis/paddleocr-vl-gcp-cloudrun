# PaddleOCR-VL API - Google Cloud Run

API OCR ad alte prestazioni basata su PaddleOCR-VL, deployata su Google Cloud Run con GPU NVIDIA L4.

## 🚀 Quick Start

```bash
# Setup e deploy
cd scripts/deployment
./setup.sh
./deploy.sh
```

## 📚 Documentazione

- **[README Completo](docs/README.md)** - Documentazione tecnica dettagliata
- **[Quick Start](docs/QUICKSTART.md)** - Guida rapida per iniziare
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Risoluzione problemi comuni

### Deployment
- [Deploy Notes v7](docs/deployment/DEPLOY_FINAL_V7.md)
- [Deploy Success](docs/deployment/DEPLOY_SUCCESS.md)
- [Deployment Checklist](docs/deployment/DEPLOYMENT_CHECKLIST.md)

### Architettura
- [Dimensioni e Risorse](docs/architecture/DIMENSIONI_E_RISORSE.md)
- [Project Structure](docs/architecture/PROJECT_STRUCTURE.md)
- [Phase 2 Notes](docs/architecture/PHASE2_NOTES.md)

### Testing
- [Test Wrapper PDF](docs/testing/TEST_WRAPPER_PDF.md)
- [Analisi Wrapper PDF](docs/testing/ANALISI_WRAPPER_PDF.md)

## 📁 Struttura Progetto

```
paddleocr-vl/
├── README.md                 # Questo file
├── Dockerfile                # Immagine Docker
├── requirements.txt          # Dipendenze Python
├── server.py                 # FastAPI server
├── pdf_processor.py          # Processing PDF
├── .env.example              # Template variabili ambiente
├── .dockerignore            # File esclusi da Docker
├── .gitignore               # File esclusi da Git
│
├── docs/                     # Documentazione
│   ├── README.md            # Documentazione completa
│   ├── QUICKSTART.md        # Guida rapida
│   ├── TROUBLESHOOTING.md   # Risoluzione problemi
│   ├── deployment/          # Docs deployment
│   ├── architecture/        # Docs architettura
│   └── testing/             # Docs testing
│
├── scripts/                  # Scripts
│   ├── deployment/          # Deploy e setup
│   │   ├── deploy.sh
│   │   ├── setup.sh
│   │   └── VERIFICATION.sh
│   ├── testing/             # Testing
│   │   ├── run_local.sh
│   │   └── test_local.py
│   └── utilities/           # Utilities
│       └── examples.sh
│
├── tests/                    # Test files
│   ├── samples/             # PDF di test
│   └── results/             # Risultati OCR
│
└── logs/                     # Logs
    └── archive/             # Logs archiviati
```

## 🎯 Features

- ✅ OCR ad alte prestazioni con PaddleOCR-VL
- ✅ GPU NVIDIA L4 (24GB VRAM)
- ✅ Filtro intelligente pagine vuote (ROI-based)
- ✅ API OpenAI-compatible
- ✅ Processing multi-pagina
- ✅ Output Markdown strutturato

## 🔗 Service URL

**Production**: https://paddleocr-vl-api-kyus437a3q-ew.a.run.app

### Endpoints

- `GET /health` - Health check
- `POST /ocr` - OCR diretto (multipart/form-data)
- `POST /v1/chat/completions` - API OpenAI-compatible

## 📊 Performance

- **Startup**: ~10 secondi (modello pre-caricato)
- **Processing**: ~30 sec/pagina
- **Accuracy**: Alta (testo, tabelle, formule)
- **Filtro pagine vuote**: Riduzione significativa tempo/costi (varia per documento)

## 💰 Costi

- **Development**: $70-150/mese
- **Production**: $500-600/mese (always-on)

## 🛠️ Tecnologie

- **Model**: PaddleOCR-VL 0.9B
- **Framework**: FastAPI + PyTorch 2.3
- **PDF**: pypdfium2 (GPL-free)
- **Platform**: Google Cloud Run + GPU L4
- **Container**: Docker + CUDA 12.1

## 📝 License

Proprietario - Uso interno

---

**Versione**: v9  
**Ultimo deploy**: 19 Novembre 2025  
**Status**: ✅ Production Ready
