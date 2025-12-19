# Shared Services - GPU

GPU 기반 AI/ML 서비스 모음

## 디렉토리 구조

```
shared-services-gpu/
├── embedding/                      # 임베딩 서비스
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── app.py
│
├── qwen3-vl-32b-thinking/         # Vision Language Model
│   ├── vllm/
│   │   ├── docker-compose.yml
│   │   └── download_model.sh
│   └── ollama/
│       └── Modelfile
│
├── gpt-oss-120b/                   # Large Language Model
│   ├── vllm/
│   │   ├── docker-compose.yml
│   │   └── download_model.sh
│   └── ollama/
│       └── Modelfile
│
├── kanana-2-30b-a3b-thinking/     # Korean Language Model
│   ├── vllm/
│   │   ├── docker-compose.yml
│   │   └── download_model.sh
│   └── ollama/
│       └── Modelfile
│
└── functiongemma-270m-it/          # Function Calling Model
    ├── vllm/
    │   ├── docker-compose.yml
    │   └── download_model.sh
    └── ollama/
        └── Modelfile
```

## 서비스 목록

### 1. Embedding Service
- **경로**: [embedding/](embedding/)
- **포트**: 설정 파일 참조
- **설명**: 텍스트 임베딩 생성 서비스

### 2. Qwen3-VL-32B-Thinking (Vision Language Model)
- **경로**: [qwen3-vl-32b-thinking/](qwen3-vl-32b-thinking/)
- **포트**: 8001
- **모델**: `Qwen/Qwen3-VL-32B-Thinking`
- **설명**: 비전-언어 멀티모달 모델
- **GPU**: 1개 사용 (DGX Spark 통합 메모리)

### 3. GPT-OSS-120B (Large Language Model)
- **경로**: [gpt-oss-120b/](gpt-oss-120b/)
- **포트**: 8002
- **모델**: `openai/gpt-oss-120b`
- **설명**: 대규모 언어 모델
- **GPU**: 1개 사용 (DGX Spark 통합 메모리)

### 4. Kanana-2-30B-A3B-Thinking (Korean Language Model)
- **경로**: [kanana-2-30b-a3b-thinking/](kanana-2-30b-a3b-thinking/)
- **포트**: 8003
- **모델**: `kakaocorp/kanana-2-30b-a3b-thinking`
- **설명**: 한국어 특화 사고 모델
- **GPU**: 1개 사용 (DGX Spark 통합 메모리)

### 5. FunctionGemma-270M-IT (Function Calling Model)
- **경로**: [functiongemma-270m-it/](functiongemma-270m-it/)
- **포트**: 8004
- **모델**: `google/functiongemma-270m-it`
- **설명**: 함수 호출 특화 소형 모델
- **GPU**: 1개 사용 (DGX Spark 통합 메모리)

## 사용 방법

### 모델 다운로드

각 서비스의 vLLM 디렉토리에서 다운로드 스크립트 실행:

```bash
# Qwen3-VL-32B-Thinking
cd qwen3-vl-32b-thinking/vllm
./download_model.sh

# GPT-OSS-120B
cd gpt-oss-120b/vllm
./download_model.sh

# Kanana-2-30B-A3B-Thinking
cd kanana-2-30b-a3b-thinking/vllm
./download_model.sh

# FunctionGemma-270M-IT
cd functiongemma-270m-it/vllm
./download_model.sh
```

모델은 HuggingFace 기본 캐시 경로(`~/.cache/huggingface/hub`)에 저장됩니다.

### 서비스 실행

#### vLLM으로 실행
```bash
# Qwen3-VL-32B-Thinking
cd qwen3-vl-32b-thinking/vllm
docker-compose up -d

# GPT-OSS-120B
cd gpt-oss-120b/vllm
docker-compose up -d

# Kanana-2-30B-A3B-Thinking
cd kanana-2-30b-a3b-thinking/vllm
docker-compose up -d

# FunctionGemma-270M-IT
cd functiongemma-270m-it/vllm
docker-compose up -d

# Embedding
cd embedding
docker-compose up -d
```

#### Ollama로 실행
```bash
# 대부분의 모델은 vLLM만 사용하도록 설정됨 (ollama 비활성화)
# GPT-OSS-120B (Ollama 사용 가능)
cd gpt-oss-120b/ollama
ollama create gpt-oss-120b -f Modelfile
ollama run gpt-oss-120b
```

## API 엔드포인트

- **Qwen3-VL-32B-Thinking**: `http://localhost:8001/v1`
- **GPT-OSS-120B**: `http://localhost:8002/v1`
- **Kanana-2-30B-A3B-Thinking**: `http://localhost:8003/v1`
- **FunctionGemma-270M-IT**: `http://localhost:8004/v1`
- **Embedding**: 설정 파일 참조

## 요구사항

- Docker & Docker Compose
- NVIDIA GPU & nvidia-docker runtime
- Python 3.12+
- HuggingFace Hub (`pip install huggingface_hub`)
