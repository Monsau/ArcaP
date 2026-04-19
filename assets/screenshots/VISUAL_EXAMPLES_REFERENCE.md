# 📸 Visual Examples Reference - What to Capture

This document provides textual descriptions of what each screenshot should contain based on the actual platform.

---

## Screenshot 1: AI Chat UI - Main Interface
**File**: `01-ai-chat-ui-main.png`

### Visual Elements to Capture:
```
┌─────────────────────────────────────────────────────────────┐
│  ☰ SIDEBAR                                                    │
│                                                               │
│  [Talentys Logo - Monochrome, 80px, Centered]               │
│                                                               │
│  📋 Configuration                                             │
│    └─ LLM Model: [llama3.1 ▼]                               │
│    └─ Temperature: [━━●━━━━━━] 0.70                         │
│    └─ Top K Documents: [━━━●━━━━] 5                         │
│                                                               │
│  📤 Upload Documents                                          │
│  🗄️ Database Ingestion                                       │
│  ℹ️ About                                                     │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│  MAIN CHAT AREA                                               │
│                                                               │
│  💬 Assistant IA de Données                                   │
│                                                               │
│  Bonjour! Je suis votre assistant IA pour l'analyse de      │
│  données. Posez-moi vos questions sur vos données.           │
│                                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ 🧑 User: Quels sont les datasets disponibles?       │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ 🤖 Assistant: J'ai trouvé 3 datasets...             │    │
│  │    • MinIO_Storage: 1 dataset                       │    │
│  │    • Elasticsearch_Logs: 3 indices                  │    │
│  │    • PostgreSQL_BusinessDB: 7 tables                │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ Type your message here...                            │    │
│  │                                                  [📨] │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                               │
│  FOOTER:                                                      │
│  📊 Talentys Data Platform v1.1.0 (AI-Ready)                 │
└─────────────────────────────────────────────────────────────┘
```

### Key Points:
- ✅ Talentys monochrome logo visible and centered (80px)
- ✅ Version "v1.1.0 (AI-Ready)" in footer
- ✅ Model "llama3.1" displayed
- ✅ Configuration sidebar with sliders
- ✅ Clean Google-style interface
- ✅ Light mode theme

---

## Screenshot 2: AI Chat UI - Upload Section
**File**: `02-ai-chat-ui-upload.png`

### Visual Elements:
```
┌─────────────────────────────────────────────────────────────┐
│  📤 Upload Documents                                          │
│                                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  📁 Drag & Drop Files Here                          │    │
│  │                                                       │    │
│  │      or click to browse                              │    │
│  │                                                       │    │
│  │  Supported formats:                                  │    │
│  │  PDF, DOCX, DOC, TXT, XLSX, XLS, CSV, JSON, MD      │    │
│  │                                                       │    │
│  │  Max file size: 200MB                                │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                               │
│  📊 Stored Documents: 53                                      │
│                                                               │
│  Recent uploads:                                              │
│  ✅ sales_report_q3_2024.pdf (2.4 MB)                        │
│  ✅ customer_data.xlsx (1.8 MB)                               │
│  ✅ product_catalog.docx (500 KB)                             │
│  ✅ marketing_metrics.csv (350 KB)                            │
│  ✅ technical_documentation.md (120 KB)                       │
│                                                               │
│  [🗑️ Clear All]  [📥 Download List]                         │
└─────────────────────────────────────────────────────────────┘
```

### Key Points:
- ✅ Drag & drop zone visible
- ✅ "53 stored documents" displayed
- ✅ Supported formats list (8 types)
- ✅ 200MB file size limit
- ✅ Recent uploads with file sizes

---

## Screenshot 3: AI Chat UI - Database Ingestion
**File**: `03-ai-chat-ui-database-ingest.png`

### Visual Elements:
```
┌─────────────────────────────────────────────────────────────┐
│  🗄️ Database Ingestion                                       │
│                                                               │
│  Connect to your databases and automatically ingest data     │
│  into the vector database for AI-powered queries.            │
│                                                               │
│  ┌─ PostgreSQL ────────────────────────────────────────┐    │
│  │  Host: postgres                                      │    │
│  │  Port: 5432                                          │    │
│  │  Database: businessdb                                │    │
│  │  User: admin                                         │    │
│  │  [🔌 Connect]                                        │    │
│  └──────────────────────────────────────────────────────┘    │
│                                                               │
│  ┌─ Dremio ─────────────────────────────────────────────┐    │
│  │  Host: dremio                                        │    │
│  │  Port: 9047                                          │    │
│  │  Username: dremio                                    │    │
│  │  [🔌 Connect]                                        │    │
│  └──────────────────────────────────────────────────────┘    │
│                                                               │
│  Status:                                                      │
│  ✅ PostgreSQL: Connected (7 tables ingested)                │
│  ✅ Dremio: Connected (3 datasets ingested)                  │
│                                                               │
│  Total records in vector DB: 15,832                          │
└─────────────────────────────────────────────────────────────┘
```

### Key Points:
- ✅ PostgreSQL connection form
- ✅ Dremio connection form
- ✅ Connection status (green checkmarks)
- ✅ Tables/datasets counts
- ✅ Total records in vector DB

---

## Screenshot 4: Dremio - Home Dashboard
**File**: `04-dremio-home-dashboard.png`

### Visual Elements:
```
┌─────────────────────────────────────────────────────────────┐
│  DREMIO                                        [👤 dremio]   │
│  ─────────────────────────────────────────────────────────  │
│  🏠 Home  |  📊 Datasets  |  🔍 SQL Editor  |  ⚙️ Settings   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  📁 Spaces                                                    │
│  ┌────────────────┐ ┌────────────────┐ ┌────────────────┐  │
│  │ 📂 analytics   │ │ 📂 marts       │ │ 📂 raw         │  │
│  │    6 datasets  │ │    0 datasets  │ │    3 datasets  │  │
│  └────────────────┘ └────────────────┘ └────────────────┘  │
│  ┌────────────────┐                                          │
│  │ 📂 staging     │                                          │
│  │    2 datasets  │                                          │
│  └────────────────┘                                          │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  🔌 Sources                                                   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ 💾 Object Storage                                     │   │
│  │   └─ MinIO_Storage (1 dataset)                       │   │
│  │       └─ sales-data                                   │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ 🗃️ Databases                                          │   │
│  │   ├─ Elasticsearch_Logs (3 indices)                  │   │
│  │   │   ├─ test-index-1                                │   │
│  │   │   ├─ test-index-2                                │   │
│  │   │   └─ test-index-3                                │   │
│  │   └─ PostgreSQL_BusinessDB (7 tables)                │   │
│  │       ├─ customers                                    │   │
│  │       ├─ orders                                       │   │
│  │       ├─ products                                     │   │
│  │       └─ ...                                          │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Key Points:
- ✅ Spaces: analytics (6), marts (0), raw (3), staging (2)
- ✅ Sources: MinIO_Storage (1), Elasticsearch_Logs (3), PostgreSQL (7)
- ✅ Professional data lakehouse interface
- ✅ Clear navigation bar

---

## Screenshot 5: Dremio - SQL Query Editor
**File**: `05-dremio-sql-query-editor.png`

### Visual Elements:
```
┌─────────────────────────────────────────────────────────────┐
│  SQL EDITOR                                                   │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ 1  SELECT *                                          │    │
│  │ 2  FROM "MinIO_Storage"."sales-data"                 │    │
│  │ 3  LIMIT 100;                                        │    │
│  │                                                       │    │
│  └─────────────────────────────────────────────────────┘    │
│  [▶ Run]  [⚙️ Preview]  [💾 Save]                           │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  RESULTS (13,440 rows)                                        │
│  ┌───┬────────────┬─────────┬──────────┬──────────┬───┐     │
│  │ID │ Date       │ Product │ Quantity │ Revenue  │...│     │
│  ├───┼────────────┼─────────┼──────────┼──────────┼───┤     │
│  │ 1 │ 2024-01-15 │ Widget  │ 25       │ $1,250   │...│     │
│  │ 2 │ 2024-01-16 │ Gadget  │ 18       │ $2,700   │...│     │
│  │ 3 │ 2024-01-17 │ Tool    │ 42       │ $4,200   │...│     │
│  │...│ ...        │ ...     │ ...      │ ...      │...│     │
│  └───┴────────────┴─────────┴──────────┴──────────┴───┘     │
│  Showing 100 of 13,440 rows                                  │
└─────────────────────────────────────────────────────────────┘

┌─ METADATA ────────────────────────────────────────────────┐
│  📊 Dataset: sales-data                                    │
│  📁 Path: "MinIO_Storage"."sales-data"                     │
│  📅 Created: Oct 10, 2024                                  │
│  🔄 Updated: Oct 15, 2024                                  │
│  📈 Jobs (last 30 days): 4                                 │
│                                                            │
│  Columns (11):                                             │
│  • id (INTEGER)                                            │
│  • date (DATE)                                             │
│  • product (VARCHAR)                                       │
│  • quantity (INTEGER)                                      │
│  • revenue (DECIMAL)                                       │
│  • ...                                                     │
└────────────────────────────────────────────────────────────┘
```

### Key Points:
- ✅ SQL editor with syntax highlighting
- ✅ Query: `SELECT * FROM "MinIO_Storage"."sales-data"`
- ✅ Results table showing 13,440 rows
- ✅ Metadata sidebar with 11 columns
- ✅ Jobs count (4 in last 30 days)

---

## Screenshot 6-9: Other Services

### Screenshot 6: Superset BI Dashboard
- Interactive charts (bar, line, pie)
- Business metrics with professional data
- Dashboard title and filters
- Clean BI interface

### Screenshot 7: Airbyte Connections
- Source → Destination connections list
- Sync status (green checkmarks)
- Connection names and types
- Recent sync timestamps

### Screenshot 8: dbt Documentation
- Data lineage graph visualization
- Model dependencies (nodes and edges)
- SQL transformation preview
- Professional documentation layout

### Screenshot 9: Platform Services Overview
- Docker Desktop or Portainer view
- 17 services all with green status:
  * postgres, minio, dremio
  * airbyte-server, airbyte-worker
  * superset
  * ollama, qdrant
  * rag-api, chat-ui
  * dbt-docs
  * elasticsearch
- CPU/Memory usage (low/normal)
- All ports exposed and accessible

---

## 🎨 Design Consistency

### Colors (Talentys Palette)
- **Primary Blue**: #0066CC
- **Dark Blue**: #003D7A
- **Light Gray**: #F5F5F5
- **White**: #FFFFFF
- **Text**: #333333

### Typography
- **Headings**: Segoe UI, 16-24px, Bold
- **Body**: Segoe UI, 14px, Regular
- **Monospace**: Consolas, 12px (code)

### Spacing
- **Padding**: 16px (standard)
- **Margins**: 24px between sections
- **Border Radius**: 8px (cards)

---

**Use this as a reference when capturing actual screenshots!**  
Follow `PLATFORM_SCREENSHOTS_GUIDE.md` for exact technical specifications.

© 2025 Talentys - Visual Documentation Standards
