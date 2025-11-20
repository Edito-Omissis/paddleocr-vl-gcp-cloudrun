# PaddleOCR-VL API - Google Cloud Run

API OCR ad alte prestazioni basata su PaddleOCR-VL, deployata su Google Cloud Run con GPU NVIDIA L4.

**Versione Attuale (v0.6.0)**: Estrazione testo da PDF con rilevamento intelligente pagine vuote.

## ✨ Funzionalità

- 🚀 **OCR Accelerato GPU**: NVIDIA L4 GPU (24GB VRAM) per inferenza veloce
- 🧠 **Rilevamento Pagine Vuote**: Analisi varianza ROI riduce tempi di elaborazione
- 🌍 **Supporto Multilingua**: 109 lingue supportate da PaddleOCR-VL
- 📄 **Estrazione Testo**: Estrae testo da PDF, tabelle, formule e grafici
- 🔌 **API Compatibile OpenAI**: Sostituzione diretta per endpoint OpenAI
- 📊 **Statistiche Dettagliate**: Metriche di elaborazione per pagina
- 🐳 **Production-Ready**: Container Docker ottimizzato per Cloud Run
- 📝 **Output Testo Plain**: Estrazione testo pulito (v0.6.0)

## 🗺️ Roadmap

### v0.6.0 (Attuale) ✅

**Stato**: Production-ready  
**Data Rilascio**: Novembre 2025

**Funzionalità**:
- Estrazione testo plain da documenti PDF
- Rilevamento intelligente pagine vuote tramite analisi varianza ROI
- Endpoint API compatibili OpenAI (`/v1/chat/completions`)
- Accelerazione GPU con NVIDIA L4 (24GB VRAM)
- Elaborazione documenti multi-pagina
- Supporto 109 lingue tramite modello PaddleOCR-VL

**Stack Tecnico**:
- Inferenza: Approccio basato su Transformers con `AutoModelForCausalLM`
- Framework: PyTorch 2.3.0 con CUDA 12.1
- Deployment: Google Cloud Run con supporto GPU

---

### v0.7.0 (In Sviluppo) 🚧

**Rilascio Previsto**: Dicembre 2025  
**Focus**: Output markdown strutturato con rilevamento layout

**Funzionalità Principali**:
- **Output Markdown Strutturato**: Formattazione corretta con titoli (`#`, `##`), tabelle (`|`), liste ed enfasi (`**`, `*`)
- **Pipeline Pre-processing Documenti**:
  - Classificazione orientamento (rilevamento e correzione 0°, 90°, 180°, 270°)
  - Document unwarping (correzione rotazioni 1-5° e rimozione distorsioni prospettiche)
- **Rilevamento Layout**: PP-DocLayoutV2 con RT-DETR per riconoscimento accurato struttura documento
- **Riconoscimento Tabelle Avanzato**: Formato markdown table con allineamento celle corretto
- **Intelligenza Ordine Lettura**: Sequenziamento corretto elementi (alto-basso, sinistra-destra)

**Modifiche Tecniche**:
- Migrazione da PyTorch/Transformers a ecosistema PaddlePaddle
- Integrazione pipeline ufficiale PaddleOCR con classe `PaddleOCRVL`
- Elaborazione multi-stadio: orientamento → unwarping → rilevamento layout → riconoscimento elementi
- Supporto CUDA 12.6 per PaddlePaddle 3.2.0

**Performance Attese**:
- Velocità elaborazione: ~0.8-1.0 pagine/secondo su GPU L4
- Efficienza memoria: ~40% riduzione rispetto a v0.6.0
- Accuratezza layout: 95%+ con pipeline pre-processing

---

### v0.8.0 (Pianificata) 📐

**Rilascio Previsto**: Q1 2026  
**Focus**: Estrazione elementi e analisi spaziale

**Funzionalità Pianificate**:
- **Crop Elementi**: Estrazione elementi individuali documento (blocchi testo, tabelle, figure) come immagini separate
- **Estrazione Immagini**: Salvataggio immagini incorporate, grafici e diagrammi da documenti
- **Rilevamento Bounding Box**: Coordinate spaziali precise per tutti gli elementi rilevati
- **Classificazione Elementi**: Categorizzazione automatica (titolo, paragrafo, tabella, figura, formula)
- **Relazioni Spaziali**: Preservazione informazioni posizionamento relativo

**Casi d'Uso**:
- Segmentazione documenti per elaborazione downstream
- Generazione dati training per modelli ML
- Analisi documenti granulare
- Ricostruzione layout personalizzata

---

### v0.9.0 (Pianificata) 📋

**Rilascio Previsto**: Q2 2026  
**Focus**: Generazione DOCX con preservazione formattazione

**Funzionalità Pianificate**:
- **Generazione DOCX**: Conversione diretta da PDF a formato Microsoft Word
- **Incorporamento Immagini**: Inserimento automatico immagini estratte nelle posizioni corrette
- **Formattazione Avanzata**:
  - Preservazione stili e dimensioni font
  - Spaziatura e allineamento paragrafi
  - Bordi tabelle e formattazione celle
  - Rilevamento intestazioni e piè di pagina
- **Layout Multi-colonna**: Supporto strutture documento complesse
- **Preservazione Metadati**: Proprietà documento, informazioni autore, data creazione

**Approccio Tecnico**:
- Integrazione con libreria `python-docx`
- Engine mapping layout-to-DOCX
- Inferenza stile da elementi visuali
- Formattazione basata su template

---

### v1.0.0 (Release Stabile) 🎯

**Rilascio Previsto**: Q3 2026  
**Focus**: Release production-ready con funzionalità complete

**Obiettivi**:
- **Feature Complete**: Tutte le funzionalità pianificate da v0.6-v0.9 implementate e testate
- **Performance Ottimizzate**:
  - Supporto elaborazione batch per scenari high-throughput
  - Ottimizzazione memoria per documenti grandi (100+ pagine)
  - Accelerazione inferenza con backend vLLM o SGLang
- **Hardening Produzione**:
  - Gestione errori e recovery completa
  - Logging e monitoring estensivi
  - Rate limiting e gestione risorse
- **Documentazione**:
  - Riferimento API completo
  - Guide integrazione per framework comuni
  - Raccomandazioni tuning performance
  - Guide troubleshooting
- **Testing**:
  - 90%+ copertura codice
  - Test integrazione per tutti gli endpoint
  - Benchmark performance su tipi documento
  - Stress testing per richieste concorrenti

**Metriche Qualità**:
- Uptime: 99.9% SLA
- Accuratezza elaborazione: 98%+ per documenti standard
- Tempo risposta API: < 5s per documenti tipici
- Supporto 109 lingue con qualità consistente

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

**Versione**: v0.6.0  
**Ultimo deploy**: 20 Novembre 2025  
**Status**: ✅ Production Ready
