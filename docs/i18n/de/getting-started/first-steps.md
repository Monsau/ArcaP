# Erste Schritte mit der Datenplattform

**Version**: 3.2.0  
**Letzte Aktualisierung**: 16.10.2025  
**Sprache**: Französisch

---

## Übersicht

Dieses Tutorial führt Sie durch Ihre ersten Interaktionen mit der Datenplattform, von der Verbindung mit Diensten bis zum Aufbau Ihrer ersten Datenpipeline mit Airbyte, Dremio, dbt und Superset.

```mermaid
graph LR
    A[Accéder aux Services] --> B[Configurer Airbyte]
    B --> C[Connecter Dremio]
    C --> D[Créer Modèles dbt]
    D --> E[Construire Tableau de Bord]
    E --> F[Pipeline Complet]
    
    style F fill:#90EE90
    style A fill:#87CEEB
```

**Geschätzte Zeit**: 60-90 Minuten

---

## Voraussetzungen

Bevor Sie beginnen, stellen Sie sicher, dass:

- ✅ Alle Dienste sind installiert und laufen
- ✅ Sie können auf Webschnittstellen zugreifen
- ✅ Die virtuelle Python-Umgebung ist aktiviert
- ✅ Grundverständnis von SQL

**Überprüfen Sie, ob die Dienste funktionieren:**
```bash
docker-compose ps
docker-compose -f docker-compose-airbyte.yml ps
```

---

## Schritt 1: Zugriff auf alle Dienste

### Dienst-URLs

| Dienstleistungen | URL | Standardanmeldeinformationen |
|---------|----------|----------|
| **Airbyte** | http://localhost:8000 | airbyte@example.com / Passwort |
| **Dremio** | http://localhost:9047 | admin/admin123 |
| **Obermenge** | http://localhost:8088 | admin / admin |
| **MinIO** | http://localhost:9001 | minioadmin / minioadmin123 |

### Erste Verbindung

**Airbyte:**
1. Öffnen Sie http://localhost:8000
2. Schließen Sie den Einrichtungsassistenten ab
3. Arbeitsbereichsnamen festlegen: „Produktion“
4. Präferenzen überschreiben (spätere Konfiguration möglich)

**Dremio:**
1. Öffnen Sie http://localhost:9047
2. Erstellen Sie beim ersten Zugriff einen Administratorbenutzer:
   - Benutzername: `admin`
   - E-Mail: `admin@example.com`
   - Passwort: `admin123`
3. Klicken Sie auf „Erste Schritte“

**Obermenge:**
1. Öffnen Sie http://localhost:8088
2. Melden Sie sich mit den Standardanmeldeinformationen an
3. Passwort ändern: Einstellungen → Benutzerinfo → Passwort zurücksetzen

---

## Schritt 2: Konfigurieren Sie Ihre erste Datenquelle in Airbyte

### Erstellen Sie eine PostgreSQL-Quelle

**Szenario**: Daten aus einer PostgreSQL-Datenbank extrahieren.

1. **Zu Quellen navigieren**
   - Klicken Sie im linken Menü auf „Quellen“.
   - Klicken Sie auf „+ Neue Quelle“

2. **PostgreSQL auswählen**
   - Suchen Sie nach „PostgreSQL“
   - Klicken Sie auf den „PostgreSQL“-Connector

3. **Verbindung konfigurieren**
   ```yaml
   Source name: Production PostgreSQL
   Host: postgres
   Port: 5432
   Database: dremio_db
   Username: postgres
   Password: postgres123
   SSL Mode: prefer
   Replication Method: Standard
   ```

4. **Testen und speichern**
   - Klicken Sie auf „Quelle einrichten“
   - Warten Sie den Verbindungstest ab
   - Quelle erstellt ✅

### Beispieldaten erstellen (optional)

Wenn Sie noch keine Daten haben, erstellen Sie Beispieltabellen:

```sql
-- Se connecter à PostgreSQL
docker exec -it postgres psql -U postgres -d dremio_db

-- Créer des tables exemples
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    amount DECIMAL(10,2),
    status VARCHAR(20),
    order_date DATE DEFAULT CURRENT_DATE
);

-- Insérer des données exemples
INSERT INTO customers (name, email, country) VALUES
    ('John Doe', 'john@example.com', 'USA'),
    ('Jane Smith', 'jane@example.com', 'UK'),
    ('Carlos Garcia', 'carlos@example.com', 'Spain'),
    ('Marie Dubois', 'marie@example.com', 'France'),
    ('Yuki Tanaka', 'yuki@example.com', 'Japan');

INSERT INTO orders (customer_id, amount, status) VALUES
    (1, 150.00, 'completed'),
    (1, 250.00, 'completed'),
    (2, 300.00, 'pending'),
    (3, 120.00, 'completed'),
    (4, 450.00, 'completed'),
    (5, 200.00, 'shipped');

-- Vérifier les données
SELECT * FROM customers;
SELECT * FROM orders;
```

---

## Schritt 3: MinIO S3-Ziel konfigurieren

### Erstellen Sie ein Ziel

1. **Zu Zielen navigieren**
   - Klicken Sie im linken Menü auf „Ziele“.
   - Klicken Sie auf „+ Neues Ziel“

2. **S3 auswählen**
   - Suchen Sie nach „S3“
   - Klicken Sie auf den „S3“-Anschluss

3. **MinIO als S3 konfigurieren**
   ```yaml
   Destination name: MinIO Data Lake
   S3 Bucket Name: datalake
   S3 Bucket Path: raw-data
   S3 Bucket Region: us-east-1
   S3 Endpoint: http://minio:9000
   Access Key ID: minioadmin
   Secret Access Key: minioadmin123
   
   Output Format:
     Format Type: Parquet
     Compression: GZIP
     Block Size (Row Group Size): 128 MB
   ```

4. **Testen und speichern**
   - Klicken Sie auf „Ziel einrichten“
   - Verbindungstest sollte bestanden werden ✅

---

## Schritt 4: Erstellen Sie Ihre erste Verbindung

### Quelle mit Ziel verknüpfen

1. **Navigieren Sie zu Verbindungen**
   - Klicken Sie im linken Menü auf „Verbindungen“.
   - Klicken Sie auf „+ Neue Verbindung“

2. **Quelle auswählen**
   - Wählen Sie „PostgreSQL-Produktion“
   - Klicken Sie auf „Vorhandene Quelle verwenden“

3. **Ziel auswählen**
   - Wählen Sie „MinIO Data Lake“
   - Klicken Sie auf „Vorhandenes Ziel verwenden“

4. **Synchronisierung konfigurieren**
   ```yaml
   Connection name: PostgreSQL → MinIO
   Replication frequency: Every 24 hours at 02:00
   Destination Namespace: Custom format
     Format: production_${SOURCE_NAMESPACE}
   
   Streams to sync:
     ☑ customers
       Sync mode: Full Refresh | Overwrite
       Primary key: customer_id
       Cursor field: created_at
       
     ☑ orders
       Sync mode: Incremental | Append
       Primary key: order_id
       Cursor field: order_date
   ```

5. **Normalisierung**
   ```yaml
   Normalization: Disabled
   # Nous utiliserons dbt pour les transformations
   ```

6. **Sichern und Synchronisieren**
   - Klicken Sie auf „Verbindung einrichten“
   - Klicken Sie auf „Jetzt synchronisieren“, um die erste Synchronisierung durchzuführen
   - Überwachen Sie den Synchronisierungsfortschritt

### Synchronisierung überwachen

```mermaid
sequenceDiagram
    participant PG as PostgreSQL
    participant AB as Airbyte Worker
    participant S3 as MinIO S3
    
    AB->>PG: 1. Extraction: SELECT * FROM customers
    PG->>AB: 2. Retour données (5 lignes)
    AB->>AB: 3. Transformation en Parquet
    AB->>S3: 4. Téléversement vers datalake/raw-data/
    
    AB->>PG: 5. Extraction: SELECT * FROM orders WHERE order_date > last_sync
    PG->>AB: 6. Retour nouvelles données
    AB->>AB: 7. Transformation en Parquet
    AB->>S3: 8. Téléversement vers datalake/raw-data/
    
    Note over AB: Synchronisation Terminée ✅
```

**Synchronisierungsstatus prüfen:**
- Der Status sollte „Erfolgreich“ (grün) anzeigen.
- Synchronisierte Datensätze: ~11 (5 Kunden + 6 Bestellungen)
- Einzelheiten finden Sie in den Protokollen

---

## Schritt 5: Dremio mit MinIO verbinden

### Fügen Sie eine S3-Quelle in Dremio hinzu

1. **Zu Quellen navigieren**
   - Öffnen Sie http://localhost:9047
   - Klicken Sie auf „Quelle hinzufügen“ (+ Symbol)

2. **S3 auswählen**
   - Wählen Sie „Amazon S3“
   - Als MinIO konfigurieren:

```yaml
General:
  Name: MinIOLake

Connection:
  Authentication: AWS Access Key
  AWS Access Key: minioadmin
  AWS Secret Key: minioadmin123
  
  Encrypt connection: No
  
Advanced Options:
  Connection Properties:
    fs.s3a.path.style.access: true
    fs.s3a.endpoint: minio:9000
    dremio.s3.compat: true
  
  Root Path: /
  
  Enable compatibility mode: Yes
```

3. **Testen und speichern**
   - Klicken Sie auf „Speichern“
   - Dremio analysiert MinIO-Buckets

### Daten durchsuchen

1. **Navigieren Sie zur MinIOLake-Quelle**
   - Entwickeln Sie „MinIOLake“
   - Entwickeln Sie den „Datalake“-Bucket
   - Erweitern Sie den Ordner „raw-data“.
   - Siehe den Ordner „Production_public“.

2. **Vorschaudaten**
   - Klicken Sie auf den Ordner „Kunden“.
   - Klicken Sie auf die Parquet-Datei
   - Klicken Sie auf „Vorschau“, um die Daten anzuzeigen
   - Die Daten müssen mit PostgreSQL übereinstimmen ✅

### Erstellen Sie einen virtuellen Datensatz

1. **Daten abfragen**
   ```sql
   -- Dans Dremio SQL Runner
   SELECT *
   FROM MinIOLake.datalake."raw-data".production_public.customers
   LIMIT 100;
   ```

2. **Als VDS speichern**
   - Klicken Sie auf „Ansicht speichern unter“
   - Name: `vw_customers`
   - Space: `@admin` (Ihr Space)
   - Klicken Sie auf „Speichern“

3. **Daten formatieren** (optional)
   - Klicken Sie auf `vw_customers`
   - Verwenden Sie die Schnittstelle, um Spalten umzubenennen und Typen zu ändern
   - Beispiel: `customer_id` in `id` umbenennen

---

## Schritt 6: DBT-Vorlagen erstellen

### Initialisieren Sie das dbt-Projekt

```bash
# Activer l'environnement virtuel
source venv/bin/activate  # Linux/macOS
# ou
.\venv\Scripts\activate  # Windows

# Naviguer vers le répertoire dbt
cd dbt

# Tester la connexion
dbt debug

# Devrait afficher: "All checks passed!"
```

### Quelldefinition erstellen

**Datei**: `dbt/models/sources.yml`

```yaml
version: 2

sources:
  - name: airbyte_raw
    description: Données brutes des synchronisations Airbyte
    database: MinIOLake.datalake."raw-data".production_public
    tables:
      - name: customers
        description: Données maîtres clients
        columns:
          - name: customer_id
            description: Identifiant unique du client
            tests:
              - unique
              - not_null
          - name: email
            tests:
              - unique
              - not_null
      
      - name: orders
        description: Transactions de commandes
        columns:
          - name: order_id
            description: Identifiant unique de la commande
            tests:
              - unique
              - not_null
          - name: customer_id
            description: Clé étrangère vers customers
            tests:
              - not_null
              - relationships:
                  to: source('airbyte_raw', 'customers')
                  field: customer_id
```

### Erstellen Sie eine Staging-Vorlage

**Datei**: `dbt/models/staging/stg_customers.sql`

```sql
-- Modèle de staging: Nettoyer et standardiser les données clients

{{ config(
    materialized='view',
    schema='staging'
) }}

with source as (
    select * from {{ source('airbyte_raw', 'customers') }}
),

cleaned as (
    select
        customer_id,
        trim(name) as customer_name,
        lower(trim(email)) as email,
        upper(trim(country)) as country_code,
        created_at,
        current_timestamp() as dbt_loaded_at
    from source
)

select * from cleaned
```

**Datei**: `dbt/models/staging/stg_orders.sql`

```sql
-- Modèle de staging: Nettoyer et standardiser les données de commandes

{{ config(
    materialized='view',
    schema='staging'
) }}

with source as (
    select * from {{ source('airbyte_raw', 'orders') }}
),

cleaned as (
    select
        order_id,
        customer_id,
        amount,
        lower(trim(status)) as order_status,
        order_date,
        current_timestamp() as dbt_loaded_at
    from source
    where amount > 0  -- Filtre de qualité des données
)

select * from cleaned
```

### Erstellen Sie eine Mart-Vorlage

**Datei**: `dbt/models/marts/fct_customer_orders.sql`

```sql
-- Table de faits: Résumé des commandes clients

{{ config(
    materialized='table',
    schema='marts'
) }}

with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

customer_metrics as (
    select
        customer_id,
        count(*) as total_orders,
        sum(amount) as total_spent,
        avg(amount) as avg_order_value,
        min(order_date) as first_order_date,
        max(order_date) as last_order_date,
        sum(case when order_status = 'completed' then 1 else 0 end) as completed_orders
    from orders
    group by customer_id
),

final as (
    select
        c.customer_id,
        c.customer_name,
        c.email,
        c.country_code,
        c.created_at as customer_since,
        
        coalesce(m.total_orders, 0) as total_orders,
        coalesce(m.total_spent, 0) as lifetime_value,
        coalesce(m.avg_order_value, 0) as avg_order_value,
        m.first_order_date,
        m.last_order_date,
        coalesce(m.completed_orders, 0) as completed_orders,
        
        datediff('day', m.last_order_date, current_date()) as days_since_last_order,
        
        case
            when m.total_orders >= 5 then 'VIP'
            when m.total_orders >= 2 then 'Regular'
            else 'New'
        end as customer_segment
        
    from customers c
    left join customer_metrics m on c.customer_id = m.customer_id
)

select * from final
```

### Führen Sie dbt-Modelle aus

```bash
# Exécuter tous les modèles
dbt run

# Devrait afficher:
# Completed successfully
# Done. PASS=3 WARN=0 ERROR=0 SKIP=0 TOTAL=3

# Exécuter les tests
dbt test

# Générer la documentation
dbt docs generate
dbt docs serve  # Ouvre le navigateur sur localhost:8080
```

### Checken Sie in Dremio ein

```sql
-- Vérifier les vues de staging
SELECT * FROM "@admin".staging.stg_customers;
SELECT * FROM "@admin".staging.stg_orders;

-- Vérifier la table mart
SELECT * FROM "@admin".marts.fct_customer_orders
ORDER BY lifetime_value DESC;
```

---

## Schritt 7: Erstellen Sie ein Dashboard in Superset

### Dremio-Datenbank hinzufügen

1. **Zu Datenbanken navigieren**
   - Öffnen Sie http://localhost:8088
   - Klicken Sie auf „Daten“ → „Datenbanken“
   - Klicken Sie auf „+ Datenbank“

2. **Dremio auswählen**
   ```yaml
   Database name: Dremio Lakehouse
   SQLAlchemy URI: dremio+flight://admin:admin123@dremio:32010
   
   Test connection: ✅ Succès
   ```

3. **Klicken Sie auf „Verbinden“**

### Erstellen Sie einen Datensatz

1. **Zu Datensätzen navigieren**
   - Klicken Sie auf „Daten“ → „Datensätze“
   - Klicken Sie auf „+ Datensatz“

2. **Konfigurieren Sie den Datensatz**
   ```yaml
   Database: Dremio Lakehouse
   Schema: @admin.marts
   Table: fct_customer_orders
   ```

3. **Klicken Sie auf „Datensatz erstellen und Diagramm erstellen“**

### Diagramme erstellen

#### Diagramm 1: Kundensegmente (Kreisdiagramm)

```yaml
Chart Type: Pie Chart
Datasource: fct_customer_orders

Dimensions:
  - customer_segment

Metrics:
  - COUNT(customer_id)

Filters: Aucun

Chart Options:
  Show Labels: Yes
  Show Legend: Yes
```

#### Diagramm 2: Einkommen nach Ländern (Balkendiagramm)

```yaml
Chart Type: Bar Chart
Datasource: fct_customer_orders

Dimensions:
  - country_code

Metrics:
  - SUM(lifetime_value)

Sort by: SUM(lifetime_value) DESC
Limit: 10

Chart Options:
  Show Labels: Yes
  Color Scheme: Superset Colors
```

#### Diagramm 3: Kundenkennzahlen (große Zahl)

```yaml
Chart Type: Big Number
Datasource: fct_customer_orders

Metric: COUNT(DISTINCT customer_id)
Subheader: Total Clients

Chart Options:
  Number Format: ,d
```

### Erstellen Sie das Dashboard

1. **Zu Dashboards navigieren**
   - Klicken Sie auf „Dashboards“
   - Klicken Sie auf „+ Dashboard“

2. **Konfigurieren Sie das Dashboard**
   ```yaml
   Title: Analytique Clients
   Slug: customer-analytics
   Owners: admin
   Published: Yes
   ```

3. **Grafiken hinzufügen**
   - Ziehen Sie die erstellten Grafiken per Drag & Drop
   - In einem Raster organisieren:
     ```
     [ Total Clients      ]
     [ Segments ] [ Revenu par Pays ]
     ```

4. **Filter hinzufügen** (optional)
   - Klicken Sie auf „Filter hinzufügen“
   - Filtern nach: Ländercode
   - Auf alle Diagramme anwenden

5. **Dashboard speichern**

---

## Schritt 8: Überprüfen Sie die vollständige Pipeline

### End-to-End-Tests

```mermaid
graph LR
    A[PostgreSQL<br/>Données Source] -->|Sync Airbyte| B[MinIO S3<br/>Données Brutes]
    B -->|Requête Dremio| C[dbt<br/>Transformations]
    C -->|Écriture| D[Dremio<br/>Marts]
    D -->|Requête SQL| E[Superset<br/>Tableau de Bord]
    
    style A fill:#336791,color:#fff
    style B fill:#C72E49,color:#fff
    style C fill:#FF694B,color:#fff
    style D fill:#FDB515
    style E fill:#20A7C9,color:#fff
```

### Neue Daten hinzufügen

1. **Neue Datensätze in PostgreSQL einfügen**
   ```sql
   docker exec -it postgres psql -U postgres -d dremio_db
   
   INSERT INTO customers (name, email, country) VALUES
       ('Emma Wilson', 'emma@example.com', 'USA'),
       ('Li Wei', 'li@example.com', 'China');
   
   INSERT INTO orders (customer_id, amount, status) VALUES
       (6, 500.00, 'completed'),
       (7, 350.00, 'pending');
   ```

2. **Airbyte-Synchronisierung auslösen**
   - Öffnen Sie die Airbyte-Schnittstelle
   - Gehen Sie zur Verbindung „PostgreSQL → MinIO“
   - Klicken Sie auf „Jetzt synchronisieren“
   - Warte auf das Ende ✅

3. **DBT ausführen**
   ```bash
   cd dbt
   dbt run
   ```

4. **Aktualisieren Sie das Superset-Dashboard**
   - Öffnen Sie das Dashboard
   - Klicken Sie auf die Schaltfläche „Aktualisieren“.
   - Neue Daten sollten erscheinen ✅

### Datenfluss prüfen

```sql
-- Dans Dremio SQL Runner

-- 1. Vérifier les données brutes d'Airbyte
SELECT COUNT(*) as raw_customers
FROM MinIOLake.datalake."raw-data".production_public.customers;
-- Devrait retourner: 7

-- 2. Vérifier la vue de staging
SELECT COUNT(*) as staged_customers
FROM "@admin".staging.stg_customers;
-- Devrait retourner: 7

-- 3. Vérifier la table mart
SELECT
    customer_segment,
    COUNT(*) as customers,
    SUM(lifetime_value) as total_revenue
FROM "@admin".marts.fct_customer_orders
GROUP BY customer_segment
ORDER BY total_revenue DESC;
```

---

## Schritt 9: Automatisieren Sie die Pipeline

### Planen Sie die Airbyte-Synchronisierung

Bereits für die Ausführung alle 24 Stunden um 02:00 Uhr konfiguriert.

Zum Bearbeiten:
1. Verbindung in Airbyte öffnen
2. Gehen Sie zur Registerkarte „Einstellungen“.
3. Aktualisieren Sie „Replikationshäufigkeit“
4. Speichern

### Planen Sie dbt-Ausführungen

**Option 1: Cron-Job (Linux)**
```bash
# Éditer crontab
crontab -e

# Ajouter exécution dbt à 2h30 quotidiennement (après sync Airbyte)
30 2 * * * cd /path/to/dremiodbt/dbt && /path/to/venv/bin/dbt run >> /var/log/dbt.log 2>&1
```

**Option 2: Python-Skript**

**Datei**: `scripts/run_pipeline.py`
```python
#!/usr/bin/env python3
"""
Exécution automatisée du pipeline
Exécute les modèles dbt après la synchronisation Airbyte
"""

import subprocess
import logging
from pathlib import Path

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def run_dbt():
    """Exécuter les modèles dbt"""
    dbt_dir = Path(__file__).parent.parent / 'dbt'
    
    logger.info("Exécution des modèles dbt...")
    result = subprocess.run(
        ['dbt', 'run'],
        cwd=dbt_dir,
        capture_output=True,
        text=True
    )
    
    if result.returncode == 0:
        logger.info("Exécution dbt terminée avec succès")
        return True
    else:
        logger.error(f"Échec exécution dbt: {result.stderr}")
        return False

if __name__ == '__main__':
    success = run_dbt()
    exit(0 if success else 1)
```

### Planen Sie mit Docker Compose

**Datei**: `docker-compose.scheduler.yml`
```yaml
version: '3.8'

services:
  dbt-scheduler:
    image: ghcr.io/dbt-labs/dbt-core:1.12.4
    volumes:
      - ./dbt:/usr/app/dbt
    command: >
      sh -c "while true; do
        dbt run --profiles-dir /usr/app/dbt;
        sleep 3600;
      done"
    networks:
      - dremio_network
```

---

## Nächste Schritte

Glückwunsch! Sie haben eine vollständige End-to-End-Datenpipeline aufgebaut. 🎉

### Erfahren Sie mehr

1. **Airbyte Advanced** – [Airbyte-Integrationsleitfaden](../guides/airbyte-integration.md)
2. **Dremio-Optimierung** – [Dremio-Setup-Anleitung](../guides/dremio-setup.md)
3. **Komplexe DBT-Modelle** – [DBT-Entwicklungsleitfaden](../guides/dbt-development.md)
4. **Erweiterte Dashboards** – [Superset Dashboards Guide](../guides/superset-dashboards.md)
5. **Datenqualität** – [Datenqualitätsleitfaden](../guides/data-quality.md)

### Fehlerbehebung

Wenn Sie Probleme haben, sehen Sie sich Folgendes an:
- [Anleitung zur Fehlerbehebung](../guides/troubleshooting.md)
- [Installationsanleitung](installation.md#troubleshooting)
- [Konfigurationshandbuch](configuration.md)

---

## Zusammenfassung

Sie haben erfolgreich:

- ✅ Greifen Sie auf die 7 Dienste der Plattform zu
- ✅ Konfigurieren Sie eine Airbyte-Quelle (PostgreSQL)
- ✅ Konfigurieren Sie ein Airbyte-Ziel (MinIO S3)
- ✅ Erstellen Sie Ihre erste Airbyte-Verbindung
- ✅ Dremio mit MinIO verbinden
- ✅ DBT-Vorlagen erstellen (Staging + Marts)
- ✅ Erstellen Sie ein Superset-Dashboard
- ✅ Überprüfen Sie den End-to-End-Datenfluss
- ✅ Automatisieren Sie die Pipeline-Ausführung

**Ihre Datenplattform ist jetzt betriebsbereit!** 🚀

---

**Version des Handbuchs „Erste Schritte“**: 3.2.0  
**Letzte Aktualisierung**: 16.10.2025  
**Verwaltet von**: Data Platform Team