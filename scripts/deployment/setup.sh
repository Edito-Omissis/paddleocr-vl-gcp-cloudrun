#!/bin/bash
# Setup rapido per omissis-edito-dev

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Setup PaddleOCR-VL per omissis-edito-dev ===${NC}"
echo ""

# Configura variabili d'ambiente
export GCP_PROJECT_ID="omissis-edito-dev"
export GCP_REGION="europe-west1"
export SERVICE_NAME="paddleocr-vl-api"
export REPOSITORY_NAME="paddleocr-repo"

echo -e "${YELLOW}Configurazione:${NC}"
echo "  Project ID: $GCP_PROJECT_ID"
echo "  Region: $GCP_REGION"
echo "  Service: $SERVICE_NAME"
echo ""

# Verifica gcloud
echo -e "${YELLOW}Verifica gcloud CLI...${NC}"
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}❌ gcloud non trovato. Installa Google Cloud SDK.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ gcloud trovato${NC}"

# Verifica autenticazione
echo ""
echo -e "${YELLOW}Verifica autenticazione...${NC}"
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q "@"; then
    echo -e "${YELLOW}⚠️  Non autenticato. Eseguo gcloud auth login...${NC}"
    gcloud auth login
fi
echo -e "${GREEN}✅ Autenticato${NC}"

# Imposta progetto
echo ""
echo -e "${YELLOW}Imposto progetto...${NC}"
gcloud config set project "$GCP_PROJECT_ID"
echo -e "${GREEN}✅ Progetto impostato${NC}"

# Abilita API
echo ""
echo -e "${YELLOW}Abilito API necessarie...${NC}"
gcloud services enable \
    run.googleapis.com \
    artifactregistry.googleapis.com \
    cloudbuild.googleapis.com \
    --project="$GCP_PROJECT_ID"
echo -e "${GREEN}✅ API abilitate${NC}"

# Verifica quota GPU
echo ""
echo -e "${YELLOW}Verifica quota GPU L4...${NC}"
echo "  Controlla manualmente su:"
echo "  https://console.cloud.google.com/iam-admin/quotas?project=$GCP_PROJECT_ID"
echo "  Cerca: 'Cloud Run GPU L4' per region $GCP_REGION"
echo ""

# Salva variabili in file temporaneo
cat > .env.local << EOF
# Configurazione generata automaticamente
# $(date)

export GCP_PROJECT_ID="$GCP_PROJECT_ID"
export GCP_REGION="$GCP_REGION"
export SERVICE_NAME="$SERVICE_NAME"
export REPOSITORY_NAME="$REPOSITORY_NAME"
EOF

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ Setup completato!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Variabili d'ambiente salvate in .env.local"
echo ""
echo "Per deployare:"
echo "  source .env.local"
echo "  ./deploy.sh"
echo ""
echo "Oppure direttamente:"
echo "  ./deploy.sh"
echo ""
