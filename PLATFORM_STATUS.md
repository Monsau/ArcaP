# 🚀 DATA PLATFORM v1.0 (AI-Ready) - CURRENT STATUS

**Date**: October 16, 2025 - 20:45  
**Status**: ✅ **ALL SERVICES STARTED** (21 services: 15 data platform + 6 AI)

---

## 🎯 QUICK START

### Automatic Orchestration (Recommended)

Use **orchestrate_platform.py** for one-command deployment:

```bash
# Windows PowerShell - Full deployment (Data Platform + AI)
$env:PYTHONIOENCODING="utf-8"
python -u orchestrate_platform.py

# Linux/Mac - Full deployment
python orchestrate_platform.py

# Skip AI services (Data Platform only)
python orchestrate_platform.py --skip-ai
```

**This script automatically:**
1. ✅ Checks prerequisites (Docker, Docker Compose, Python)
2. ✅ Starts all Docker services
3. ✅ **Deploys AI services (Ollama LLM + Milvus + RAG API + Chat UI)**
4. ✅ Launches Airbyte for data integration
5. ✅ Configures dbt environment and runs models
6. ✅ Synchronizes Dremio data to PostgreSQL
7. ✅ Creates Superset dashboards
8. ✅ Generates Open Data HTML dashboard
9. ✅ **Sets up local LLM (Llama 3.1) and downloads models**

**Output:**
- Real-time progress with emojis (ℹ️ ✅ ❌ ⚠️)
- Step-by-step execution status
- Final deployment summary
- Service URLs and credentials (including AI services)

**Options:**
```bash
python orchestrate_platform.py --help              # Show all options
python orchestrate_platform.py --skip-infrastructure  # Skip Docker start
python orchestrate_platform.py --skip-ai           # Skip AI services deployment
python orchestrate_platform.py --workspace /path    # Custom workspace
```

### Manual Launch

```bash
# Start full stack (Data Platform + AI Services)
docker-compose -f docker-compose.yml -f docker-compose-airbyte-stable.yml -f docker-compose-ai.yml up -d

# Start data platform only (no AI)
docker-compose -f docker-compose.yml -f docker-compose-airbyte-stable.yml up -d

# Start main services only
docker-compose up -d
```

---

## 📊 ACTIVE SERVICES

### 1. Base Infrastructure

| Service | Port | URL | Status |
|---------|------|-----|--------|
| PostgreSQL | 5432 | `postgresql://localhost:5432` | ✅ Healthy |
| MinIO Console | 9001 | http://localhost:9001 | ✅ Healthy |
| MinIO API | 9000 | http://localhost:9000 | ✅ Healthy |
| Elasticsearch | 9200 | http://localhost:9200 | ✅ Healthy |
| OpenMetadata MySQL | 3307 | `localhost:3307` | ✅ Healthy |

**MinIO Credentials:**
- Username: `minioadmin`
- Password: `minioadmin`

### 2. Lakehouse & Transformation

| Service | Port | URL | Status |
|---------|------|-----|--------|
| Dremio UI | 9047 | http://localhost:9047 | ✅ Running |
| Dremio JDBC | 31010 | `jdbc:dremio:localhost:31010` | ✅ Running |
| Dremio PostgreSQL Proxy | 31010 | `postgresql://localhost:31010` | ✅ Running |
| Dremio Arrow Flight | 32010 | `grpc://localhost:32010` | ✅ Running |
| Dremio Polaris (Iceberg) | 8181 | http://localhost:8181 | ✅ Running |

**Dremio Credentials:**
- First launch → Create admin account via UI

**Note:** Dremio exposes a PostgreSQL-compatible interface on port 31010, allowing any PostgreSQL client to query data directly.

### 3. Data Integration

| Service | Port | URL | Status |
|---------|------|-----|--------|
| Airbyte UI | 8000 | http://localhost:8000 | ✅ Running |
| Airbyte API | 8001 | http://localhost:8001 | ✅ Running |
| Airbyte Temporal | 7233 | `localhost:7233` | ✅ Running |

**Airbyte Credentials:**
- Default: `airbyte` / `password`
- First launch → Setup wizard

**Airbyte Features:**
- 300+ data connectors (databases, APIs, files, cloud storage)
- CDC (Change Data Capture) support
- Incremental sync with cursor fields
- Schedule-based or continuous replication

### 4. Orchestration & BI

| Service | Port | URL | Status |
|---------|------|-----|--------|
| Apache Airflow | 8080 | http://localhost:8080 | ✅ Running |
| Airflow Scheduler | - | - | ✅ Running |
| Apache Superset | 8088 | http://localhost:8088 | ✅ Healthy |
| Superset PostgreSQL | - | - | ✅ Running |
| Superset Redis | - | - | ✅ Running |

**Airflow Credentials:**
- Username: `airflow`
- Password: `airflow`

**Superset Credentials:**
- Username: `admin`
- Password: `admin`

### 5. Data Catalog

| Service | Port | URL | Status |
|---------|------|-----|--------|
| OpenMetadata | 8585 | http://localhost:8585 | ⏳ Starting |

**OpenMetadata Credentials:**
- Username: `admin`
- Password: `admin`

### 6. AI Services (NEW)

| Service | Port | URL | Status |
|---------|------|-----|--------|
| **AI Chat UI** | 8501 | http://localhost:8501 | ✅ Running |
| Ollama (Local LLM) | 11434 | http://localhost:11434 | ✅ Running |
| RAG API | 8002 | http://localhost:8002 | ✅ Running |
| RAG API Docs | 8002 | http://localhost:8002/docs | ✅ Running |
| Milvus Vector DB (gRPC) | 19530 | `grpc://localhost:19530` | ✅ Running |
| Milvus Metrics | 9091 | http://localhost:9091 | ✅ Running |
| Embedding Service | 8001 | http://localhost:8001 | ✅ Running |
| Data Ingestion Service | - | - | ✅ Running |

**AI Capabilities:**
- 🤖 **Local LLM**: Llama 3.1 (8B parameters) running fully on-premise
- 🧠 **Vector Database**: Milvus with 384-dimensional embeddings (all-MiniLM-L6-v2)
- 📚 **RAG System**: Retrieval Augmented Generation for context-aware answers
- 💬 **Natural Language Queries**: Ask questions about your data in plain English
- 🔄 **Auto-Ingestion**: Scheduled data updates from PostgreSQL/Dremio (hourly/daily/weekly)
- 🔒 **100% Private**: No cloud APIs, no data leaves your infrastructure

**Quick Start - AI Services:**

1. **Access Chat UI**: http://localhost:8501
2. **Ingest Data** (via sidebar):
   - PostgreSQL table: `customers` (text column: `description`)
   - Or use API: `curl -X POST http://localhost:8002/ingest/postgres -d '{"table": "customers", "text_column": "description"}'`
3. **Ask Questions**:
   - "What are our top products?"
   - "Show me customer trends"
   - "Generate SQL for sales analysis"

**Available LLM Models:**
- ✅ **llama3.1** (default) - 5GB, best quality
- ⬇️ **mistral** - `docker exec ollama ollama pull mistral` (fast, coding)
- ⬇️ **phi3** - `docker exec ollama ollama pull phi3` (lightweight, 2GB)

**Health Checks:**
```bash
# RAG API status
curl http://localhost:8002/health

# Embedding service status
curl http://localhost:8001/health

# List available LLM models
docker exec ollama ollama list

# Milvus metrics
curl http://localhost:9091/metrics
```

**Troubleshooting:**
- If Ollama fails to start: `docker restart ollama && docker logs -f ollama`
- If no search results: Ingest data first via Chat UI or API
- For GPU acceleration: Uncomment GPU config in `docker-compose-ai.yml`

---

## 🔧 ORCHESTRATION

### Orchestration Script
**File**: `orchestrate_platform.py`

**Applied Fixes:**
- ✅ UTF-8 encoding fix for Windows
- ✅ Unicode/emoji support
- ✅ Airbyte integration

**Launch Command:**
```bash
$env:PYTHONIOENCODING="utf-8"
python -u orchestrate_platform.py
```

**Orchestration Steps:**
1. ✅ Prerequisites check (Docker, Docker Compose, Python)
2. ✅ Docker infrastructure deployment (including Airbyte)
3. ⏳ Dremio configuration (sources, reflections)
4. ⏳ dbt deployment (models, tests, docs)
5. ⏳ Dremio → PostgreSQL synchronization
6. ⏳ Apache Superset configuration
7. ⏳ Automatic dashboard creation
8. ⏳ Final report generation

---

## 📁 ARCHITECTURE

```
Data Platform v1.0
│
├── Sources (PostgreSQL, CSV, APIs, Databases)
│   └── Airbyte → Data Ingestion (300+ connectors)
│       ├── Full Refresh
│       ├── Incremental Sync
│       └── CDC (Change Data Capture)
│
├── Storage Layer
│   ├── MinIO (S3) → Data Lake (Bronze/Silver/Gold)
│   └── PostgreSQL → Transactional DB
│
├── Processing Layer
│   ├── Dremio → Lakehouse SQL Engine
│   │   └── PostgreSQL Proxy (port 31010)
│   ├── Dremio Polaris → Apache Iceberg Catalog
│   └── dbt → Transformations (Silver → Gold)
│
├── Orchestration
│   └── Apache Airflow → Workflows & Scheduling
│
├── Analytics & BI
│   └── Apache Superset → Dashboards & Visualizations
│
└── Governance
    └── OpenMetadata → Data Catalog & Lineage
```

---

## 🎯 NEXT STEPS

### 1. Wait for Stabilization (~2 minutes)
All services should reach `healthy` status:
```bash
docker ps --format "table {{.Names}}\t{{.Status}}"
```

### 2. Initial Configuration

#### Airbyte (http://localhost:8000)
1. Complete setup wizard
2. Create source connectors:
   - PostgreSQL: `dremio-postgres:5432`
   - REST API: Configure your APIs
   - CSV/JSON: Upload files
3. Create destination connectors:
   - MinIO S3: `http://dremio-minio:9000`
   - PostgreSQL: `dremio-postgres:5432`
4. Setup connections and sync schedules

#### Dremio (http://localhost:9047)
1. Create administrator account
2. Add data sources:
   - PostgreSQL (`dremio-postgres:5432`)
   - MinIO S3 (`http://dremio-minio:9000`)
   - Elasticsearch (`http://dremio-elasticsearch:9200`)
3. Configure reflections for query acceleration
4. **PostgreSQL Proxy**: Connect any PostgreSQL client to `localhost:31010`

**Example: Connect via psql to Dremio**
```bash
psql -h localhost -p 31010 -U <your-dremio-username>
```

#### Superset (http://localhost:8088)
1. Login: `admin` / `admin`
2. Add Dremio connection:
   - Type: `PostgreSQL`
   - Host: `dremio`
   - Port: `31010`
   - Database: Dremio
   - User: Your Dremio username
   
#### Airflow (http://localhost:8080)
1. Login: `airflow` / `airflow`
2. Activate demo DAGs
3. Create connections to Dremio and Airbyte
4. Setup data pipelines:
   - Airbyte sync triggers
   - dbt transformations
   - Data quality checks

### 3. Re-run Orchestrator
```bash
$env:PYTHONIOENCODING="utf-8"
python -u orchestrate_platform.py
```

Or configure manually:
- dbt: `cd dbt_project && dbt run`
- Superset dashboards: Manual configuration via UI

---

## 🐛 TROUBLESHOOTING

### Issue: Service won't start
```bash
# Check logs
docker logs <container_name>

# Restart service
docker restart <container_name>
```

### Issue: Port already in use
```bash
# Find process
netstat -ano | findstr :<PORT>

# Stop all containers
docker-compose down
docker-compose -f docker-compose.yml -f docker-compose-airbyte.yml down
```

### Issue: Airbyte not accessible
```bash
# Check Airbyte services
docker ps | findstr airbyte

# Restart Airbyte stack
docker-compose -f docker-compose.yml -f docker-compose-airbyte.yml restart
```

### Issue: Unicode encoding in orchestrator
**Applied Solution**: Fix in `orchestrate_platform.py`
```python
if sys.platform == 'win32':
    import codecs
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout.buffer, 'strict')
    sys.stderr = codecs.getwriter('utf-8')(sys.stderr.buffer, 'strict')
```

---

## � INTEGRATION EXAMPLES

### Connect Python to Dremio PostgreSQL Proxy
```python
import psycopg2

conn = psycopg2.connect(
    host="localhost",
    port=31010,
    user="your-dremio-username",
    password="your-dremio-password",
    database="Dremio"
)

# Query data like regular PostgreSQL
cursor = conn.cursor()
cursor.execute("SELECT * FROM my_dataset LIMIT 10")
results = cursor.fetchall()
```

### Connect Airbyte to MinIO
**Source**: Any Airbyte connector  
**Destination**: S3 (MinIO)
- Endpoint: `http://dremio-minio:9000`
- Access Key: `minioadmin`
- Secret Key: `minioadmin`
- Bucket: `datalake`
- Path Prefix: `bronze/<source-name>/`

### Airbyte → Dremio → dbt → Superset Pipeline
1. **Airbyte**: Sync data from sources to MinIO (Bronze layer)
2. **Dremio**: Mount MinIO bucket, query with SQL
3. **dbt**: Transform Bronze → Silver → Gold layers
4. **Superset**: Visualize Gold layer via Dremio PostgreSQL proxy

---

## �📚 DOCUMENTATION

- **README.md** → General documentation (18 languages)
- **docs/** → Detailed technical documentation
- **docs/diagrams/** → Mermaid diagrams (architecture, workflows)
- **examples/** → Usage examples

---

## 🌐 REPOSITORY

**GitHub**: https://github.com/Monsau/data-platform-iso-opensource  
**Version**: 1.0.0  
**License**: MIT  
**Author**: Mustapha Fonsau (mfonsau@talentys.eu)  
**Organization**: Talentys (https://talentys.eu)

---

**Last Update**: 2025-10-16 20:45:00
