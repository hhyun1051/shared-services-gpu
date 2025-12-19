#!/bin/bash

# GPT-OSS-120B 모델 다운로드 스크립트
# HuggingFace 기본 캐시 경로 사용: ~/.cache/huggingface/hub

set -e

MODEL_NAME="openai/gpt-oss-120b"

echo "=== Downloading ${MODEL_NAME} ==="
echo "Model will be cached in: ~/.cache/huggingface/hub"

# huggingface_hub 패키지가 설치되어 있는지 확인
if ! python3 -c "import huggingface_hub" &> /dev/null; then
    echo "huggingface_hub not found. Installing..."
    pip install -U huggingface_hub --break-system-packages
fi

# Python API를 사용하여 모델 다운로드
python3 -c "from huggingface_hub import snapshot_download; snapshot_download('${MODEL_NAME}')"

echo "=== Download completed ==="
echo "Model cached at: ~/.cache/huggingface/hub"
