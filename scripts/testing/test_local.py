#!/usr/bin/env python3
"""
Script di test locale per PaddleOCR-VL API
Testa il server in esecuzione locale prima del deployment
"""

import sys
import base64
import requests
import json
from pathlib import Path


def test_health(base_url: str):
    """Test health check endpoint"""
    print("🔍 Testing /health endpoint...")
    try:
        response = requests.get(f"{base_url}/health", timeout=5)
        response.raise_for_status()
        data = response.json()
        print(f"✅ Health check OK: {data}")
        return True
    except Exception as e:
        print(f"❌ Health check failed: {e}")
        return False


def test_ocr_direct(base_url: str, pdf_path: str):
    """Test OCR diretto con file PDF"""
    print(f"\n🔍 Testing /ocr endpoint con {pdf_path}...")
    
    if not Path(pdf_path).exists():
        print(f"❌ File non trovato: {pdf_path}")
        return False
    
    try:
        with open(pdf_path, 'rb') as f:
            files = {'file': (Path(pdf_path).name, f, 'application/pdf')}
            response = requests.post(
                f"{base_url}/ocr",
                files=files,
                timeout=120
            )
        
        response.raise_for_status()
        data = response.json()
        
        print(f"✅ OCR completato:")
        print(f"   Pagine: {data.get('pages')}")
        print(f"   Caratteri: {data.get('total_chars')}")
        print(f"\n📄 Markdown (primi 500 caratteri):")
        print(data.get('markdown', '')[:500])
        print("...")
        
        return True
        
    except Exception as e:
        print(f"❌ OCR test failed: {e}")
        if hasattr(e, 'response') and e.response is not None:
            print(f"   Response: {e.response.text}")
        return False


def test_openai_api(base_url: str, pdf_path: str):
    """Test API compatibile OpenAI"""
    print(f"\n🔍 Testing /v1/chat/completions endpoint con {pdf_path}...")
    
    if not Path(pdf_path).exists():
        print(f"❌ File non trovato: {pdf_path}")
        return False
    
    try:
        # Leggi e codifica PDF in base64
        with open(pdf_path, 'rb') as f:
            pdf_bytes = f.read()
        
        pdf_base64 = base64.b64encode(pdf_bytes).decode('utf-8')
        
        # Prepara richiesta OpenAI-style
        payload = {
            "model": "paddleocr-vl",
            "messages": [
                {
                    "role": "user",
                    "content": f"data:application/pdf;base64,{pdf_base64}"
                }
            ],
            "temperature": 0.0,
            "max_tokens": 2048
        }
        
        response = requests.post(
            f"{base_url}/v1/chat/completions",
            json=payload,
            headers={"Content-Type": "application/json"},
            timeout=120
        )
        
        response.raise_for_status()
        data = response.json()
        
        print(f"✅ Chat completion OK:")
        print(f"   ID: {data.get('id')}")
        print(f"   Model: {data.get('model')}")
        print(f"   Tokens: {data.get('usage', {})}")
        
        content = data.get('choices', [{}])[0].get('message', {}).get('content', '')
        print(f"\n📄 Risposta (primi 500 caratteri):")
        print(content[:500])
        print("...")
        
        return True
        
    except Exception as e:
        print(f"❌ OpenAI API test failed: {e}")
        if hasattr(e, 'response') and e.response is not None:
            print(f"   Response: {e.response.text}")
        return False


def main():
    """Main test runner"""
    # Configurazione
    base_url = "http://localhost:8080"
    
    # Cerca un PDF di test
    test_pdf = None
    for pattern in ["test.pdf", "sample.pdf", "*.pdf"]:
        matches = list(Path(".").glob(pattern))
        if matches:
            test_pdf = str(matches[0])
            break
    
    if len(sys.argv) > 1:
        test_pdf = sys.argv[1]
    
    print("=" * 60)
    print("🧪 PaddleOCR-VL API - Test Suite")
    print("=" * 60)
    print(f"Base URL: {base_url}")
    print(f"Test PDF: {test_pdf or 'Nessuno (solo health check)'}")
    print("=" * 60)
    
    # Test 1: Health check
    health_ok = test_health(base_url)
    
    if not health_ok:
        print("\n❌ Server non disponibile. Assicurati che sia in esecuzione:")
        print("   python3 server.py")
        sys.exit(1)
    
    # Test 2 e 3: Solo se abbiamo un PDF
    if test_pdf:
        ocr_ok = test_ocr_direct(base_url, test_pdf)
        openai_ok = test_openai_api(base_url, test_pdf)
        
        print("\n" + "=" * 60)
        print("📊 Risultati:")
        print(f"   Health Check: {'✅' if health_ok else '❌'}")
        print(f"   OCR Direct:   {'✅' if ocr_ok else '❌'}")
        print(f"   OpenAI API:   {'✅' if openai_ok else '❌'}")
        print("=" * 60)
        
        if not (ocr_ok and openai_ok):
            sys.exit(1)
    else:
        print("\n⚠️  Nessun PDF di test trovato.")
        print("   Per testare gli endpoint OCR, esegui:")
        print("   python3 test_local.py path/to/test.pdf")
    
    print("\n✅ Tutti i test completati con successo!")


if __name__ == "__main__":
    main()
