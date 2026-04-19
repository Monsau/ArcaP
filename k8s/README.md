# Kubernetes Manifests

Kustomize-based manifests for deploying the ArcaP AI and governance stack on Kubernetes.

## Structure

```
k8s/
├── namespace.yaml                          # arcap namespace
├── kustomization.yaml                      # Kustomize root
├── ai/
│   ├── qdrant-deployment.yaml              # Qdrant v1.17.1 vector DB (ports 6333/6334)
│   ├── ollama-deployment.yaml              # Ollama LLM server (port 11434)
│   ├── embedding-service-deployment.yaml   # Sentence-transformer embedding (port 8001)
│   ├── rag-api-deployment.yaml             # RAG API + ConfigMap + Secrets (port 8002)
│   ├── chat-ui-deployment.yaml             # Streamlit Chat UI (port 8501)
│   └── minio-ai-deployment.yaml            # MinIO object storage for docs (ports 9002/9003)
└── openmetadata/
    └── openmetadata-deployment.yaml        # OMD server + MySQL 8.4 + ES 8.11.4 (port 8585)
```

## Prerequisites

- Kubernetes 1.28+ (or compatible)
- `kubectl` configured for your cluster
- `kustomize` v5+ (or `kubectl apply -k`)
- A default StorageClass, or set `storageClassName` in each PVC

## Deploy

```bash
# Apply everything
kubectl apply -k k8s/

# Or equivalently
kustomize build k8s/ | kubectl apply -f -
```

## Deploy a single component

```bash
kubectl apply -f k8s/ai/qdrant-deployment.yaml
kubectl apply -f k8s/openmetadata/openmetadata-deployment.yaml
```

## Access services (port-forward)

```bash
# Qdrant Web UI
kubectl port-forward -n arcap svc/qdrant 6333:6333

# Chat UI
kubectl port-forward -n arcap svc/chat-ui 8501:8501

# RAG API
kubectl port-forward -n arcap svc/rag-api 8002:8002

# OpenMetadata
kubectl port-forward -n arcap svc/openmetadata 8585:8585

# Ollama
kubectl port-forward -n arcap svc/ollama 11434:11434
```

## Configuration

### Secrets

Before deploying to production, replace the default placeholder values in:

- `k8s/ai/rag-api-deployment.yaml` — `rag-api-secrets`: set `OM_API_TOKEN`, `MINIO_ACCESS_KEY`, `MINIO_SECRET_KEY`
- `k8s/ai/minio-ai-deployment.yaml` — `minio-ai-credentials`: set `MINIO_ROOT_USER` / `MINIO_ROOT_PASSWORD`
- `k8s/openmetadata/openmetadata-deployment.yaml` — `openmetadata-mysql-secret`: set `MYSQL_ROOT_PASSWORD` / `MYSQL_PASSWORD`

For production use a secrets manager (Vault, AWS Secrets Manager, Azure Key Vault) and inject via ExternalSecrets or sealed-secrets.

### Storage class

Each PVC has a commented-out `storageClassName` line. Set it to your cluster's storage class:

```yaml
storageClassName: standard    # GKE
storageClassName: gp3         # EKS
storageClassName: managed-csi # AKS
```

### Custom images

`embedding-service`, `rag-api`, and `chat-ui` use `arcap/*` local image names. Build and push them before deploying:

```bash
docker build -t arcap/embedding-service:latest ai-services/embedding/
docker build -t arcap/rag-api:latest ai-services/rag-api/
docker build -t arcap/chat-ui:latest ai-services/chat-ui/

# Push to your registry and update the image references in the manifests
docker tag arcap/rag-api:latest <your-registry>/arcap/rag-api:latest
docker push <your-registry>/arcap/rag-api:latest
```

## Download Ollama model after deploy

```bash
kubectl exec -n arcap deployment/ollama -- ollama pull llama3.1
```

## Status check

```bash
kubectl get pods -n arcap
kubectl get svc -n arcap
kubectl get pvc -n arcap
```
