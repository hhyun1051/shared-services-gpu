# Grafana 대시보드 가이드

## 설치된 대시보드

### Node Exporter Full (Dashboard ID: 1860)
시스템 메트릭 모니터링 대시보드

**포함된 메트릭:**
- CPU 사용률 (코어별, 전체)
- 메모리 사용량
- 디스크 I/O 및 사용량
- 네트워크 트래픽
- 시스템 부하 (Load Average)
- 파일시스템 상태

**접속 방법:**
1. Grafana 로그인: http://localhost:3001
2. 좌측 메뉴 → Dashboards
3. "Node Exporter Full" 선택

## 추가 대시보드 임포트 방법

### 1. Grafana UI에서 임포트

1. Dashboards → New → Import
2. Dashboard ID 입력 (예: 1860, 11074 등)
3. Load 클릭
4. Prometheus 데이터소스 선택
5. Import 클릭

### 2. 추천 대시보드

- **1860** - Node Exporter Full (설치됨)
- **11074** - Node Exporter Dashboard EN
- **13978** - Node Exporter Quickstart
- **893** - Docker Monitoring
- **179** - Docker Prometheus Monitoring

## 문제 해결

### 대시보드가 안 보이는 경우

```bash
cd /root/shared-services-gpu/monitoring
docker-compose restart grafana
```

### 데이터가 안 나오는 경우

Prometheus 접속 확인:
```bash
curl http://localhost:9090/api/v1/targets
```
