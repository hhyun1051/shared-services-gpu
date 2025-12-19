# Shared Services - GPU Models

GPU 기반 LLM 서비스 구성

## 디렉토리 구조

```
services/
├── qwen3-vl-8b/
│   ├── vllm/
│   │   ├── docker-compose.yml      # vLLM 서버 구성
│   │   └── download_model.sh       # 모델 다운로드 스크립트
│   └── ollama/
│       └── Modelfile               # Ollama 모델 설정
│
└── gpt-oss-120b/
    ├── vllm/
    │   ├── docker-compose.yml      # vLLM 서버 구성
    │   └── download_model.sh       # 모델 다운로드 스크립트
    └── ollama/
        └── Modelfile               # Ollama 모델 설정
```

## 사용 방법

### 1. 모델 다운로드

각 모델은 HuggingFace 기본 캐시 경로(`~/.cache/huggingface/hub`)에 저장됩니다.

```bash
# Qwen3-VL-8B 모델 다운로드
cd qwen3-vl-8b/vllm
./download_model.sh

# GPT-OSS-120B 모델 다운로드
cd gpt-oss-120b/vllm
./download_model.sh
```

### 2. vLLM 서버 실행

```bash
# Qwen3-VL-8B 서버 실행 (포트: 8001)
cd qwen3-vl-8b/vllm
docker-compose up -d

# GPT-OSS-120B 서버 실행 (포트: 8002)
cd gpt-oss-120b/vllm
docker-compose up -d
```

### 3. Ollama 모델 생성

```bash
# Qwen3-VL-8B Ollama 모델 생성
cd qwen3-vl-8b/ollama
ollama create qwen3-vl-8b -f Modelfile

# GPT-OSS-120B Ollama 모델 생성
cd gpt-oss-120b/ollama
ollama create gpt-oss-120b -f Modelfile
```

## API 엔드포인트

- **Qwen3-VL-8B**: `http://localhost:8001/v1`
- **GPT-OSS-120B**: `http://localhost:8002/v1`

## 요구사항

- Docker & Docker Compose
- NVIDIA GPU & nvidia-docker runtime
- HuggingFace CLI (`pip install -U huggingface_hub[cli]`)
