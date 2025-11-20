# 📝 Changelog - PaddleOCR-VL API

## [v0.6.0] - 2025-11-20 ✅ PRIMO RILASCIO PUBBLICO

### � Rilascio Iniziale
Questo è il primo rilascio pubblico di PaddleOCR-VL API per Google Cloud Run.

### � Features
- **Integrazione PaddleOCR-VL**: Modello vision-language all'avanguardia per OCR documenti
- **Accelerazione GPU**: NVIDIA L4 GPU (24GB VRAM) su Google Cloud Run
- **Rilevamento Intelligente Pagine Vuote**: Analisi varianza basata su ROI
  - Analisi tiles 64×64 pixel
  - Soglia configurabile (varianza > 100, min 5 tiles)
  - Salta automaticamente le pagine vuote per evitare di processare contenuto inesistente
  - Riduce tempo processing e costi filtrando le pagine vuote
- **API Compatibile OpenAI**: Sostituzione diretta per endpoint OpenAI
- **Server FastAPI**: Framework web Python asincrono moderno
- **Processing PDF**: Conforme alle licenze con pypdfium2 (Apache 2.0)
- **Output Markdown**: Output testuale pulito e strutturato
- **Statistiche Dettagliate**: Metriche processing per pagina

### 🚀 Performance
- **Velocità Processing**: ~2-3 secondi per pagina con GPU
- **Rilevamento Pagine Vuote**: < 100ms overhead per pagina
- **Risparmio Costi**: Riduzione significativa saltando pagine vuote (varia per documento)
- **Scalabilità**: Auto-scaling 0-3 istanze, 10 richieste concorrenti per istanza

### � Documentazione
- Documentazione completa in inglese
- Commenti e docstring comprensivi nel codice
- Guide deployment per Google Cloud Run
- Esempi utilizzo API
- Guida troubleshooting

### 🔧 Stack Tecnico
- **Modello**: PaddlePaddle/PaddleOCR-VL (0.9B parametri)
- **Framework**: FastAPI + PyTorch
- **Rendering PDF**: pypdfium2 (Apache 2.0)
- **Container**: Docker con NVIDIA CUDA 12.1
- **Piattaforma**: Google Cloud Run con GPU L4
- **Risorse**: 4 vCPU, 16GB RAM, 1x GPU L4

### 🌍 Supporto Multilingua
- 109 lingue supportate da PaddleOCR-VL
- Riconoscimento testo, tabelle, formule e grafici

---

## 🎯 Roadmap Futuro

### v1.0.0 - Rilascio Pianificato
**Target**: Feature generazione DOCX
- Conversione output OCR in formato Microsoft Word
- Preservazione struttura e formattazione documento
- Inclusione immagini e tabelle

### Phase 2: Comprensione Avanzata Documenti
- **Integrazione PP-DocLayoutV2**: Analisi layout con RT-DETR
- **Estrazione immagini**: Rilevamento ed estrazione figure, grafici, diagrammi
- **Output DOCX**: Generazione documenti Word con immagini embedded
- **Riconoscimento tabelle**: Tabelle native Word
- **Ordine di lettura**: Mantenimento flusso e struttura documento

### Phase 3: Features Avanzate
- **Batch processing**: Multipli PDF in singola richiesta
- **Supporto webhook**: Processing asincrono per documenti grandi
- **Caching avanzato**: Evitare riprocessamento documenti identici
- **Metriche qualità**: Confidence score per elemento
- **Opzioni formato**: Output PDF, DOCX, HTML

---

**Maintained by**: Edito Omissis Development Team  
**License**: Apache 2.0  
**Repository**: https://github.com/Edito-Omissis/paddleocr-vl-gcp-cloudrun
