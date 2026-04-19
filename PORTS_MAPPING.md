# 🔌 Plan de Réorganisation des Ports - Data Platform v3.3.1

**Date**: 19 octobre 2025  
**Objectif**: Éviter les conflits de ports et faciliter l'intégration OpenMetadata 1.12.4

---

## 📊 Mapping des Ports

### Services Principaux

| Service | Ancien Port | Nouveau Port | Description |
|---------|-------------|--------------|-------------|
| **Dremio UI** | 9047 | **9047** ✅ | Interface Web Dremio |
| **Dremio JDBC** | 31010 | **31010** ✅ | Interface PostgreSQL |
| **Dremio ODBC** | 45678 | **45678** ✅ | Interface ODBC |
| **Dremio Arrow Flight** | 32010 | **32010** ✅ | Arrow Flight endpoint |

### Bases de Données

| Service | Ancien Port | Nouveau Port | Description |
|---------|-------------|--------------|-------------|
| **PostgreSQL** | 5432 | **5432** ✅ | Base de données principale |
| **MySQL (OpenMetadata)** | 3307 | **3306** → **3307** ✅ | Base OpenMetadata |

### Object Storage & Catalogues

| Service | Ancien Port | Nouveau Port | Description |
|---------|-------------|--------------|-------------|
| **MinIO API** | 9000 | **9000** ✅ | API S3 |
| **MinIO Console** | 9001 | **9001** ✅ | Interface Web MinIO |
| **Polaris Catalog** | 8181 | **8181** ✅ | Apache Polaris API |

### Metadata & Search

| Service | Ancien Port | Nouveau Port | Description |
|---------|-------------|--------------|-------------|
| **Elasticsearch HTTP** | 9200 | **9200** ✅ | API Elasticsearch |
| **Elasticsearch Transport** | 9300 | **9300** ✅ | Transport inter-nœuds |
| **OpenMetadata API** | 8585 | **8585** ✅ | OpenMetadata API + UI |
| **OpenMetadata Admin** | - | **8586** 🆕 | Port admin OpenMetadata |

### Orchestration

| Service | Ancien Port | Nouveau Port | Description |
|---------|-------------|--------------|-------------|
| **Airflow UI** | 8080 | **8080** ✅ | Interface Web Airflow |

---

## ⚠️ Ports à Éviter (Conflits Potentiels)

### Ports Système Courants
- **80, 443**: Réservés HTTP/HTTPS système
- **3306**: MySQL standard (utiliser 3307 pour OpenMetadata)
- **5000**: Flask/Python dev servers
- **8000**: Applications Python courantes
- **8888**: Jupyter Notebook

### Ports Déjà Utilisés
- **5432**: PostgreSQL (Business DB)
- **8080**: Airflow Webserver
- **8181**: Polaris Catalog
- **8585-8586**: OpenMetadata
- **9000-9001**: MinIO
- **9047**: Dremio UI
- **9200, 9300**: Elasticsearch
- **31010, 32010, 45678**: Dremio JDBC/Arrow/ODBC

---

## 🔧 Ports Disponibles pour Futurs Services

### Range 8100-8199 (Services Web)
- **8100-8109**: Libres
- **8110-8149**: Libres
- **8150-8180**: Libres
- **8181**: Polaris ✓
- **8182-8199**: Libres

### Range 8200-8299 (APIs)
- **8200-8299**: Entièrement libre

### Range 8300-8399 (Monitoring)
- **8300-8399**: Entièrement libre

### Range 8500-8599 (Metadata Services)
- **8500-8584**: Libres
- **8585-8586**: OpenMetadata ✓
- **8587-8599**: Libres

### Range 9100-9199 (Object Storage)
- **9100-9199**: Libres (MinIO utilise 9000-9001)

---

## 🎯 Recommandations

### Services à Ajouter (Ports Suggérés)

| Service Futur | Port Suggéré | Raison |
|---------------|--------------|---------|
| **Superset** | 8088 | Port standard Superset |
| **dbt Docs** | 8090 | Documentation dbt |
| **Grafana** | 3001 | Monitoring (éviter 3000) |
| **Prometheus** | 9091 | Métriques (éviter 9090) |
| **Jaeger UI** | 16686 | Tracing distribué |
| **Kafka UI** | 8089 | Gestion Kafka |
| **Schema Registry** | 8081 | Confluent Schema Registry |

---

## ✅ Configuration Validée

### Santé des Services (Health Checks)

Tous les services ont des health checks configurés :

```yaml
✅ Dremio:        http://localhost:9047
✅ PostgreSQL:    pg_isready -U postgres
✅ MySQL:         mysqladmin ping
✅ MinIO:         http://localhost:9000/minio/health/live
✅ Polaris:       http://localhost:8181/api/catalog/v1/config
✅ Elasticsearch: http://localhost:9200
✅ OpenMetadata:  http://localhost:8585/api/v1/health
✅ Airflow:       http://localhost:8080/health
```

---

## 🚀 Commandes de Vérification

### Vérifier les ports en écoute
```powershell
# Windows PowerShell
netstat -ano | Select-String "LISTENING" | Select-String -Pattern "5432|3307|8080|8181|8585|8586|9000|9001|9047|9200|9300|31010|32010|45678"

# Ou avec port spécifique
Test-NetConnection -ComputerName localhost -Port 8585
```

### Tester la connectivité
```bash
# Bash/WSL
curl http://localhost:9047      # Dremio
curl http://localhost:8585      # OpenMetadata
curl http://localhost:8080      # Airflow
curl http://localhost:9001      # MinIO Console
curl http://localhost:8181      # Polaris
curl http://localhost:9200      # Elasticsearch
```

---

## 📝 Notes de Migration

### OpenMetadata 1.9.7 → 1.12.4

**Nouveautés**:
- ✅ Support Pipeline Service Client amélioré
- ✅ Nouvelles options d'authentification
- ✅ Port admin séparé (8586)
- ✅ Meilleure intégration Elasticsearch
- ✅ Support secrets manager

**Breaking Changes**:
- Configuration `SEARCH_TYPE` requise
- `AUTHENTICATION_PROVIDER` obligatoire
- Nouveaux paramètres `SERVER_HOST_API_URL`

---

## 🔐 Ports Sécurisés (Production)

Pour un environnement de production, considérer :

1. **Reverse Proxy** (Nginx/Traefik)
   - Port 80/443 avec SSL
   - Routing interne vers services

2. **VPN/Bastion**
   - Accès sécurisé aux ports de gestion
   - Firewall pour ports internes

3. **Network Segmentation**
   - Subnet séparé pour bases de données
   - Subnet séparé pour services web
   - Subnet séparé pour stockage

---

**Validé**: ✅  
**Version Docker Compose**: 3.8  
**Services**: 11 conteneurs  
**Réseau**: bridge (172.20.0.0/16)
