#!/bin/bash
# Esempi di utilizzo dell'API PaddleOCR-VL

# Configura l'URL del servizio
SERVICE_URL="${SERVICE_URL:-http://localhost:8080}"

echo "=== PaddleOCR-VL API Examples ==="
echo "Service URL: $SERVICE_URL"
echo ""

# Esempio 1: Health Check
echo "1. Health Check"
echo "   curl $SERVICE_URL/health"
echo ""
curl -s "$SERVICE_URL/health" | jq '.'
echo ""
echo "---"
echo ""

# Esempio 2: OCR Diretto (richiede test.pdf)
if [ -f "test.pdf" ]; then
    echo "2. OCR Diretto"
    echo "   curl -X POST $SERVICE_URL/ocr -F 'file=@test.pdf'"
    echo ""
    curl -s -X POST "$SERVICE_URL/ocr" \
        -F "file=@test.pdf" | jq '.markdown' -r | head -20
    echo "   ..."
    echo ""
    echo "---"
    echo ""
else
    echo "2. OCR Diretto (SKIP - test.pdf non trovato)"
    echo ""
fi

# Esempio 3: API OpenAI-Compatible
if [ -f "test.pdf" ]; then
    echo "3. API OpenAI-Compatible"
    echo "   curl -X POST $SERVICE_URL/v1/chat/completions ..."
    echo ""
    
    # Codifica PDF in base64
    PDF_BASE64=$(base64 -w 0 test.pdf)
    
    curl -s -X POST "$SERVICE_URL/v1/chat/completions" \
        -H "Content-Type: application/json" \
        -d "{
            \"model\": \"paddleocr-vl\",
            \"messages\": [
                {
                    \"role\": \"user\",
                    \"content\": \"data:application/pdf;base64,$PDF_BASE64\"
                }
            ],
            \"temperature\": 0.0,
            \"max_tokens\": 2048
        }" | jq '.choices[0].message.content' -r | head -20
    echo "   ..."
    echo ""
else
    echo "3. API OpenAI-Compatible (SKIP - test.pdf non trovato)"
    echo ""
fi

echo "=== Fine esempi ==="
echo ""
echo "Per testare con un tuo PDF:"
echo "  SERVICE_URL=$SERVICE_URL ./examples.sh"
echo "  (assicurati che test.pdf esista nella directory corrente)"
