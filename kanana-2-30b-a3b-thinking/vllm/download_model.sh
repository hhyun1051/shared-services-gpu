#!/bin/bash

# Kanana-2-30B-A3B-Thinking 모델 다운로드 스크립트
# HuggingFace 기본 캐시 경로 사용: ~/.cache/huggingface/hub

set -e

MODEL_NAME="kakaocorp/kanana-2-30b-a3b-thinking"
TMUX_SESSION="download-kanana-2-30b"

# huggingface_hub 패키지가 설치되어 있는지 확인
if ! python3 -c "import huggingface_hub" &> /dev/null; then
    echo "huggingface_hub not found. Installing..."
    pip install -U huggingface_hub --break-system-packages
fi

# tmux 설치 확인
if ! command -v tmux &> /dev/null; then
    echo "tmux not found. Installing..."
    apt-get update && apt-get install -y tmux
fi

echo "=== Starting download in tmux session: ${TMUX_SESSION} ==="
echo "To attach: tmux attach -t ${TMUX_SESSION}"
echo "To detach: Ctrl+b then d"

# 기존 세션이 있으면 종료
tmux kill-session -t ${TMUX_SESSION} 2>/dev/null || true

# tmux 세션에서 다운로드 실행
tmux new-session -d -s ${TMUX_SESSION} "
echo '=== Downloading ${MODEL_NAME} ===';
echo 'Model will be cached in: ~/.cache/huggingface/hub';
echo '';
python3 -c \"from huggingface_hub import snapshot_download; snapshot_download('${MODEL_NAME}')\";
echo '';
echo '=== Download completed ===';
echo 'Model cached at: ~/.cache/huggingface/hub';
echo '';
echo 'Press any key to close this tmux session...';
read;
"

echo ""
echo "Download started in background tmux session!"
echo "To monitor progress: tmux attach -t ${TMUX_SESSION}"
