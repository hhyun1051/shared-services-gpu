from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from langchain_huggingface import HuggingFaceEmbeddings
from contextlib import asynccontextmanager
import torch
import gc
from typing import List

# 전역 임베더 인스턴스
embedder = None

@asynccontextmanager
async def lifespan(app: FastAPI):
    """앱 시작/종료 시 실행되는 컨텍스트"""
    global embedder
    print("🚀 임베딩 모델 로딩 중...")
    embedder = HuggingFaceEmbeddings(
        model_name="BAAI/bge-m3",
        model_kwargs={"device": "cuda:0"},
        encode_kwargs={'normalize_embeddings': True, 'batch_size': 64}
    )
    print("✅ 임베딩 모델 준비 완료")
    yield
    print("🔄 서버 종료 중...")
    del embedder
    gc.collect()
    torch.cuda.empty_cache()

app = FastAPI(title="Embedding Service", lifespan=lifespan)

# 요청/응답 모델
class EmbedRequest(BaseModel):
    text: str

class EmbedDocumentsRequest(BaseModel):
    texts: List[str]

class EmbedResponse(BaseModel):
    embedding: List[float]

class EmbedDocumentsResponse(BaseModel):
    embeddings: List[List[float]]

# API 엔드포인트
@app.get("/")
async def root():
    return {"status": "ok", "message": "Embedding Service is running"}

@app.get("/health")
async def health():
    return {"status": "healthy"}

@app.post("/embed", response_model=EmbedResponse)
async def embed_query(request: EmbedRequest):
    """단일 텍스트 임베딩"""
    try:
        embedding = embedder.embed_query(request.text)
        return {"embedding": embedding}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/embed_documents", response_model=EmbedDocumentsResponse)
async def embed_documents(request: EmbedDocumentsRequest):
    """여러 텍스트 배치 임베딩"""
    try:
        embeddings = embedder.embed_documents(request.texts)
        return {"embeddings": embeddings}
    finally:
        gc.collect()
        torch.cuda.empty_cache()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
