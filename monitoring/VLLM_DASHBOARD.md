# vLLM 모니터링 대시보드

vLLM 서비스의 성능과 상태를 실시간으로 모니터링하는 Grafana 대시보드입니다.

## 주요 메트릭

### 1. 요청 상태
- **Running Requests**: 현재 실행 중인 요청 수
- **Request Queue Status**: 대기 중(Waiting) 및 스왑된(Swapped) 요청 수
- **Request Rate**: 완료된 요청 비율 (finish reason별 분류)

### 2. 캐시 사용량
- **KV Cache Usage**: KV 캐시 블록 사용률 (0-100%)
- **GPU Cache Usage**: GPU 캐시 사용률 (0-100%)

### 3. 토큰 처리량
- **Token Throughput**:
  - Prompt Tokens/s: 프롬프트 토큰 처리 속도
  - Generation Tokens/s: 생성 토큰 처리 속도

### 4. 지연 시간 (Latency)
- **Time to First Token (TTFT)**: 첫 토큰까지 걸리는 시간
  - p50, p90, p99 백분위수
- **End-to-End Request Latency**: 전체 요청 처리 시간
  - p50, p90, p99 백분위수

## vLLM에서 제공하는 메트릭 목록

### 카운터 (Counters)
- `vllm:prompt_tokens_total` - 처리된 총 프롬프트 토큰 수
- `vllm:generation_tokens_total` - 생성된 총 토큰 수
- `vllm:request_success_total` - 완료된 요청 수 (finish_reason 라벨 포함)

### 게이지 (Gauges)
- `vllm:num_requests_running` - 현재 실행 중인 요청 수
- `vllm:num_requests_waiting` - 대기 중인 요청 수
- `vllm:num_requests_swapped` - 스왑된 요청 수
- `vllm:kv_cache_usage_perc` - KV 캐시 사용률 (0-1)
- `vllm:gpu_cache_usage_perc` - GPU 캐시 사용률 (0-1)

### 히스토그램 (Histograms)
- `vllm:time_to_first_token_seconds` - 첫 토큰까지의 시간 분포
- `vllm:e2e_request_latency_seconds` - 전체 요청 지연 시간 분포

## 대시보드 접속 방법

### 로컬 접속
```bash
# Grafana 접속
http://localhost:3001

# 로그인 정보
Username: hhyun
Password: wiplat123!@
```

### 원격 접속 (SSH 터널링)
```bash
# SSH 터널 생성
ssh -L 3001:localhost:3001 -L 9090:localhost:9090 root@<SERVER_IP>

# 브라우저에서 접속
http://localhost:3001
```

대시보드 위치: **Dashboards → vLLM Monitoring Dashboard**

## vLLM 서비스 설정

vLLM 서비스는 기본적으로 `/metrics` 엔드포인트에서 Prometheus 형식의 메트릭을 제공합니다.

### 메트릭 확인
```bash
# vLLM 메트릭 직접 확인
curl http://localhost:8002/metrics

# Prometheus에서 vLLM 타겟 상태 확인
curl http://localhost:9090/api/v1/targets | grep vllm
```

## Prometheus 설정

vLLM 메트릭 수집 설정은 `/root/shared-services-gpu/monitoring/prometheus/prometheus.yml`에 있습니다:

```yaml
- job_name: 'vllm'
  static_configs:
    - targets: ['host.docker.internal:8002']
      labels:
        instance: 'vllm-service'
```

## 문제 해결

### 메트릭이 수집되지 않는 경우

1. vLLM 서비스가 실행 중인지 확인:
```bash
curl http://localhost:8002/v1/models
```

2. vLLM 메트릭 엔드포인트 확인:
```bash
curl http://localhost:8002/metrics
```

3. Prometheus 타겟 상태 확인:
```bash
curl http://localhost:9090/api/v1/targets
```

4. Prometheus 재시작:
```bash
cd /root/shared-services-gpu/monitoring
docker compose restart prometheus
```

### 대시보드가 표시되지 않는 경우

1. Grafana 재시작:
```bash
cd /root/shared-services-gpu/monitoring
docker compose restart grafana
```

2. 대시보드 파일 확인:
```bash
ls -la /root/shared-services-gpu/monitoring/grafana/provisioning/dashboards/vllm-dashboard.json
```

## 대시보드 커스터마이징

대시보드 JSON 파일 위치:
```
/root/shared-services-gpu/monitoring/grafana/provisioning/dashboards/vllm-dashboard.json
```

변경 후 Grafana를 재시작하면 자동으로 적용됩니다:
```bash
docker compose restart grafana
```

## 참고 자료

- [vLLM Metrics Documentation](https://docs.vllm.ai/en/latest/design/metrics/)
- [NVIDIA Dynamo vLLM Prometheus](https://docs.nvidia.com/dynamo/latest/backends/vllm/prometheus.html)
- [vLLM Prometheus and Grafana Example](https://docs.vllm.ai/en/v0.7.2/getting_started/examples/prometheus_grafana.html)
