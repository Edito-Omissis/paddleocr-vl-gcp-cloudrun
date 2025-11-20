#!/bin/bash
# Script per eseguire il server localmente (richiede GPU CUDA)

set -e

# Colori
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== PaddleOCR-VL Local Server ===${NC}"
echo ""

# Verifica virtual environment
if [ ! -d ".venv" ]; then
    echo -e "${YELLOW}Virtual environment non trovato. Creazione...${NC}"
    python3 -m venv .venv
fi

# Attiva virtual environment
echo -e "${YELLOW}Attivazione virtual environment...${NC}"
source .venv/bin/activate

# Installa/aggiorna dipendenze
echo -e "${YELLOW}Installazione dipendenze...${NC}"
pip install -q --upgrade pip
pip install -q -r requirements.txt

# Verifica CUDA
echo ""
echo -e "${YELLOW}Verifica CUDA...${NC}"
python3 -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}'); print(f'CUDA version: {torch.version.cuda if torch.cuda.is_available() else \"N/A\"}')"

# Avvia server
echo ""
echo -e "${GREEN}Avvio server su http://localhost:8080${NC}"
echo -e "${YELLOW}Premi Ctrl+C per terminare${NC}"
echo ""

export PORT=8080
python3 server.py
