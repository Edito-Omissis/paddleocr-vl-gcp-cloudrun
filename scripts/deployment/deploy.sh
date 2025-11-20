#!/bin/bash
# Deployment script for Google Cloud Run with GPU L4
# PaddleOCR-VL API Server
#
# This script automates the complete deployment process:
# 1. Verifies GCP authentication
# 2. Creates Artifact Registry repository (if needed)
# 3. Builds Docker image using Cloud Build
# 4. Deploys to Cloud Run with GPU configuration
#
# Usage: bash scripts/deployment/deploy.sh (run from project root)
# Environment variables (optional):
#   GCP_PROJECT_ID: Google Cloud project ID
#   GCP_REGION: Deployment region (default: europe-west1)
#   SERVICE_NAME: Cloud Run service name
#   IMAGE_TAG: Docker image tag (default: v9)

set -e  # Exit immediately if any command fails

# Check if running from project root (Dockerfile must exist)
if [ ! -f "Dockerfile" ]; then
    echo -e "\033[0;31m❌ Error: Dockerfile not found\033[0m"
    echo "This script must be run from the project root directory."
    echo "Usage: bash scripts/deployment/deploy.sh"
    exit 1
fi

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration (modify these values or set environment variables)
PROJECT_ID="${GCP_PROJECT_ID:-omissis-edito-dev}"
REGION="${GCP_REGION:-europe-west1}"
SERVICE_NAME="${SERVICE_NAME:-paddleocr-vl-api}"
REPOSITORY_NAME="${REPOSITORY_NAME:-paddleocr-repo}"
IMAGE_NAME="${IMAGE_NAME:-paddleocr-vl}"
IMAGE_TAG="${IMAGE_TAG:-v9}"

# Cloud Run resource configuration
# See docs/architecture/DIMENSIONI_E_RISORSE.md for detailed analysis
CPU="4"              # 4 vCPU (sufficient, GPU is the bottleneck)
MEMORY="16Gi"        # 16GB RAM (handles 10 concurrent requests + buffer)
GPU_COUNT="1"        # 1x GPU L4
GPU_TYPE="nvidia-l4" # L4 = 24GB VRAM (model uses ~4GB, ample margin)
MAX_INSTANCES="3"    # Max 3 instances (auto-scaling)
MIN_INSTANCES="0"    # 0 = pay-per-use | 1 = always-on (no cold start)
CONCURRENCY="10"     # 10 parallel requests per instance
TIMEOUT="600"        # 10 minutes timeout (600s)

echo -e "${GREEN}=== PaddleOCR-VL Cloud Run Deployment ===${NC}"
echo ""

# Verify configuration
if [ "$PROJECT_ID" == "your-project-id" ]; then
    echo -e "${RED}❌ Error: Set GCP_PROJECT_ID${NC}"
    echo "Run: export GCP_PROJECT_ID=your-project-id"
    exit 1
fi

echo -e "${YELLOW}Configuration:${NC}"
echo "  Project ID: $PROJECT_ID"
echo "  Region: $REGION"
echo "  Service Name: $SERVICE_NAME"
echo "  Image: $REGION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME/$IMAGE_NAME:$IMAGE_TAG"
echo ""

# Step 1: Verify GCP authentication
echo -e "${YELLOW}[1/6] Verifying GCP authentication...${NC}"
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q "@"; then
    echo -e "${RED}❌ Not authenticated. Run: gcloud auth login${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Authenticated${NC}"

# Step 2: Set GCP project
echo -e "${YELLOW}[2/6] Setting GCP project...${NC}"
gcloud config set project "$PROJECT_ID"
echo -e "${GREEN}✅ Project set${NC}"

# Step 3: Create Artifact Registry repository (if it doesn't exist)
echo -e "${YELLOW}[3/6] Checking/Creating Artifact Registry repository...${NC}"
if ! gcloud artifacts repositories describe "$REPOSITORY_NAME" \
    --location="$REGION" &>/dev/null; then
    echo "  Creating repository..."
    gcloud artifacts repositories create "$REPOSITORY_NAME" \
        --repository-format=docker \
        --location="$REGION" \
        --description="PaddleOCR-VL Docker images"
    echo -e "${GREEN}✅ Repository created${NC}"
else
    echo -e "${GREEN}✅ Repository already exists${NC}"
fi

# Step 4: Build Docker image using Cloud Build
echo -e "${YELLOW}[4/6] Building Docker image...${NC}"
FULL_IMAGE_NAME="$REGION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME/$IMAGE_NAME:$IMAGE_TAG"

echo "  Building: $FULL_IMAGE_NAME"
# Cloud Build handles the build process on GCP infrastructure
# Timeout set to 30 minutes (PyTorch compilation takes time)
gcloud builds submit \
    --tag "$FULL_IMAGE_NAME" \
    --timeout=30m \
    .

echo -e "${GREEN}✅ Build completed${NC}"

# Step 5: Deploy to Cloud Run with GPU
echo -e "${YELLOW}[5/6] Deploying to Cloud Run with GPU L4...${NC}"

# Note: GPU support requires gcloud >= 450.0.0
# Deploy with GPU configuration and environment variables
gcloud run deploy "$SERVICE_NAME" \
    --image="$FULL_IMAGE_NAME" \
    --region="$REGION" \
    --platform=managed \
    --allow-unauthenticated \
    --cpu="$CPU" \
    --memory="$MEMORY" \
    --gpu="$GPU_COUNT" \
    --gpu-type="$GPU_TYPE" \
    --max-instances="$MAX_INSTANCES" \
    --min-instances="$MIN_INSTANCES" \
    --concurrency="$CONCURRENCY" \
    --timeout="$TIMEOUT" \
    --no-cpu-throttling \
    --no-use-http2 \
    --set-env-vars="MODEL_ID=PaddlePaddle/PaddleOCR-VL,MAX_NEW_TOKENS=2048,PDF_DPI=200"

echo -e "${GREEN}✅ Deploy completed${NC}"

# Step 6: Get service URL
echo -e "${YELLOW}[6/6] Retrieving service URL...${NC}"
SERVICE_URL=$(gcloud run services describe "$SERVICE_NAME" \
    --region="$REGION" \
    --format="value(status.url)")

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Service URL:${NC} $SERVICE_URL"
echo ""
echo -e "${YELLOW}Test endpoints:${NC}"
echo "  Health check:"
echo "    curl $SERVICE_URL/health"
echo ""
echo "  Direct OCR:"
echo "    curl -X POST $SERVICE_URL/ocr -F 'file=@your-document.pdf'"
echo ""
echo "  OpenAI-compatible API:"
echo "    curl -X POST $SERVICE_URL/v1/chat/completions \\"
echo "      -H 'Content-Type: application/json' \\"
echo "      -d '{\"model\":\"paddleocr-vl\",\"messages\":[{\"role\":\"user\",\"content\":\"data:application/pdf;base64,<BASE64_PDF>\"}]}'"
echo ""
echo -e "${YELLOW}Monitoring:${NC}"
echo "  Logs: gcloud run services logs read $SERVICE_NAME --region=$REGION --limit=50"
echo "  Console: https://console.cloud.google.com/run/detail/$REGION/$SERVICE_NAME"
echo ""
