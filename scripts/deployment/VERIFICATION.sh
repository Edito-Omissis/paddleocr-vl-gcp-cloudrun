#\!/bin/bash
# Script di verifica pre-deployment

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔍 Verifica Progetto PaddleOCR-VL API"
echo "===================================="
echo ""

# Verifica file essenziali
echo -e "${YELLOW}[1/5] Verifica file essenziali...${NC}"
REQUIRED_FILES=(
    "Dockerfile"
    "server.py"
    "pdf_processor.py"
    "requirements.txt"
    "deploy.sh"
    "test_local.py"
    "README_JUGAAD.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "  ${GREEN}✓${NC} $file"
    else
        echo -e "  ${RED}✗${NC} $file - MANCANTE\!"
        exit 1
    fi
done

# Verifica script eseguibili
echo ""
echo -e "${YELLOW}[2/5] Verifica permessi script...${NC}"
EXECUTABLE_FILES=(
    "deploy.sh"
    "run_local.sh"
    "test_local.py"
    "examples.sh"
)

for file in "${EXECUTABLE_FILES[@]}"; do
    if [ -x "$file" ]; then
        echo -e "  ${GREEN}✓${NC} $file è eseguibile"
    else
        echo -e "  ${RED}✗${NC} $file non è eseguibile"
        chmod +x "$file"
        echo -e "    ${GREEN}→${NC} Permessi corretti"
    fi
done

# Verifica sintassi Python
echo ""
echo -e "${YELLOW}[3/5] Verifica sintassi Python...${NC}"
PYTHON_FILES=(
    "server.py"
    "pdf_processor.py"
    "test_local.py"
)

for file in "${PYTHON_FILES[@]}"; do
    if python3 -m py_compile "$file" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} $file - sintassi OK"
    else
        echo -e "  ${RED}✗${NC} $file - ERRORE SINTASSI\!"
        exit 1
    fi
done

# Verifica sintassi Bash
echo ""
echo -e "${YELLOW}[4/5] Verifica sintassi Bash...${NC}"
BASH_FILES=(
    "deploy.sh"
    "run_local.sh"
    "examples.sh"
)

for file in "${BASH_FILES[@]}"; do
    if bash -n "$file" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} $file - sintassi OK"
    else
        echo -e "  ${RED}✗${NC} $file - ERRORE SINTASSI\!"
        exit 1
    fi
done

# Verifica documentazione
echo ""
echo -e "${YELLOW}[5/5] Verifica documentazione...${NC}"
DOC_FILES=(
    "README.md"
    "README_JUGAAD.md"
    "QUICKSTART.md"
    "DEPLOYMENT_CHECKLIST.md"
    "PHASE2_NOTES.md"
    "SUMMARY.md"
    "INDEX.md"
)

for file in "${DOC_FILES[@]}"; do
    if [ -f "$file" ]; then
        lines=$(wc -l < "$file")
        echo -e "  ${GREEN}✓${NC} $file ($lines righe)"
    else
        echo -e "  ${RED}✗${NC} $file - MANCANTE\!"
    fi
done

# Summary
echo ""
echo "===================================="
echo -e "${GREEN}✅ Verifica completata con successo\!${NC}"
echo ""
echo "Prossimi step:"
echo "  1. Configura: export GCP_PROJECT_ID=your-project-id"
echo "  2. Deploy:    ./deploy.sh"
echo "  3. Test:      ./examples.sh"
echo ""
echo "Documentazione: cat INDEX.md"
echo "===================================="
