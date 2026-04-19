# Comenzando con la plataforma de datos

**Versión**: 3.2.0  
**Última actualización**: 2025-10-16  
**Idioma**: Francés

---

## Descripción general

Este tutorial lo guía a través de sus primeras interacciones con la plataforma de datos, desde la conexión a los servicios hasta la creación de su primera canalización de datos con Airbyte, Dremio, dbt y Superset.

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

**Tiempo estimado**: 60-90 minutos

---

## Requisitos previos

Antes de comenzar, asegúrese de que:

- ✅ Todos los servicios están instalados y funcionando
- ✅ Puedes acceder a interfaces web
- ✅ El entorno virtual Python está habilitado
- ✅ Conocimientos básicos de SQL

**Compruebe que los servicios estén funcionando:**
```bash
docker-compose ps
docker-compose -f docker-compose-airbyte.yml ps
```

---

## Paso 1: Acceda a todos los servicios

### URL de servicio

| Servicios | URL | Credenciales predeterminadas |
|---------|----------|------------------------|
| **Airbyte** | http://localhost:8000 | airbyte@ejemplo.com / contraseña |
| **Dremio** | http://localhost:9047 | administrador/admin123 |
| **Superconjunto** | http://localhost:8088 | administrador / administrador |
| **MinIO** | http://localhost:9001 | minioadmin/minioadmin123 |

### Primera conexión

**Byte aéreo:**
1. Abra http://localhost:8000
2. Complete el asistente de configuración.
3. Establezca el nombre del espacio de trabajo: "Producción"
4. Anular las preferencias (es posible realizar una configuración posterior)

**Dremio:**
1. Abra http://localhost:9047
2. Cree un usuario administrador en el primer acceso:
   - Nombre de usuario: `admin`
   - Correo electrónico: `admin@example.com`
   - Contraseña: `admin123`
3. Haga clic en "Comenzar"

**Superconjunto:**
1. Abra http://localhost:8088
2. Inicie sesión con las credenciales predeterminadas
3. Cambiar contraseña: Configuración → Información de usuario → Restablecer contraseña

---

## Paso 2: Configura tu primera fuente de datos en Airbyte

### Crear una fuente PostgreSQL

**Escenario**: extraer datos de una base de datos PostgreSQL.

1. **Navegue a Fuentes**
   - Haga clic en "Fuentes" en el menú de la izquierda.
   - Haga clic en “+ Nueva fuente”

2. **Seleccione PostgreSQL**
   - Busque "PostgreSQL"
   - Haga clic en el conector “PostgreSQL”

3. **Configurar conexión**
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

4. **Pruebe y ahorre**
   - Haga clic en "Configurar fuente"
   - Espere la prueba de conexión.
   - Fuente creada ✅

### Crear datos de muestra (opcional)

Si aún no tiene ningún dato, cree tablas de ejemplo:

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

## Paso 3: Configurar el destino MinIO S3

### Crear un destino

1. **Navegar a Destinos**
   - Haga clic en "Destinos" en el menú de la izquierda
   - Haga clic en “+ Nuevo destino”

2. **Seleccione S3**
   - Busque "S3"
   - Haga clic en el conector “S3”

3. **Configurar MinIO como S3**
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

4. **Pruebe y ahorre**
   - Haga clic en "Configurar destino"
   - La prueba de conexión debe pasar ✅

---

## Paso 4: Crea tu primera conexión

### Vincular origen a destino

1. **Navegue a Conexiones**
   - Haga clic en "Conexiones" en el menú de la izquierda
   - Haga clic en “+ Nueva conexión”

2. **Seleccione fuente**
   - Elija "Producción PostgreSQL"
   - Haga clic en "Usar fuente existente"

3. **Seleccione Destino**
   - Elija "Lago de datos MinIO"
   - Haga clic en "Usar destino existente"

4. **Configurar sincronización**
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

5. **Normalización**
   ```yaml
   Normalization: Disabled
   # Nous utiliserons dbt pour les transformations
   ```

6. **Copia de seguridad y sincronización**
   - Haga clic en "Configurar conexión"
   - Haga clic en "Sincronizar ahora" para ejecutar la primera sincronización
   - Monitorear el progreso de la sincronización

### Sincronización de monitores

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

**Verificar estado de sincronización:**
- El estado debe mostrar "Exitoso" (verde)
- Registros sincronizados: ~11 (5 clientes + 6 pedidos)
- Ver registros para más detalles

---

## Paso 5: Conecte Dremio a MinIO

### Agregar una fuente S3 en Dremio

1. **Navegue a Fuentes**
   - Abra http://localhost:9047
   - Haga clic en "Agregar fuente" (icono +)

2. **Seleccione S3**
   - Elija "Amazon S3"
   - Configurar como MinIO:

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

3. **Pruebe y guarde**
   - Haga clic en "Guardar"
   - Dremio analizará los depósitos MinIO

### Explorar datos

1. **Navegue a la fuente de MinIOLake**
   - Desarrollar “MinIOLake”
   - Desarrollar el depósito "datalake"
   - Expandir la carpeta "datos sin procesar"
   - Ver la carpeta "production_public"

2. **Vista previa de datos**
   - Haga clic en la carpeta “clientes”
   - Haga clic en el archivo Parquet
   - Haga clic en "Vista previa" para ver los datos
   - Los datos deben coincidir con PostgreSQL ✅

### Crear un conjunto de datos virtuales

1. **Datos de consulta**
   ```sql
   -- Dans Dremio SQL Runner
   SELECT *
   FROM MinIOLake.datalake."raw-data".production_public.customers
   LIMIT 100;
   ```

2. **Guardar como VDS**
   - Haga clic en "Guardar vista como"
   - Nombre: `vw_customers`
   - Espacio: `@admin` (tu espacio)
   - Haga clic en "Guardar"

3. **Formatear datos** (opcional)
   - Haga clic en `vw_customers`
   - Utilice la interfaz para cambiar el nombre de las columnas, cambiar tipos
   - Ejemplo: Cambiar el nombre de `customer_id` a `id`

---

## Paso 6: Crear plantillas dbt

### Inicializar el proyecto dbt

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

### Crear definición de fuente

**Archivo**: `dbt/models/sources.yml`

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

### Crear una plantilla de prueba

**Archivo**: `dbt/models/staging/stg_customers.sql`

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

**Archivo**: `dbt/models/staging/stg_orders.sql`

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

### Crear una plantilla de centro comercial

**Archivo**: `dbt/models/marts/fct_customer_orders.sql`

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

### Ejecutar modelos dbt

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

### Registrarse en Dremio

```sql
-- Vérifier les vues de staging
SELECT * FROM "@admin".staging.stg_customers;
SELECT * FROM "@admin".staging.stg_orders;

-- Vérifier la table mart
SELECT * FROM "@admin".marts.fct_customer_orders
ORDER BY lifetime_value DESC;
```

---

## Paso 7: crear un panel en Superset

### Agregar base de datos Dremio

1. **Navegue a Bases de datos**
   - Abra http://localhost:8088
   - Haga clic en “Datos” → “Bases de datos”
   - Haga clic en “+ Base de datos”

2. **Seleccione Dremio**
   ```yaml
   Database name: Dremio Lakehouse
   SQLAlchemy URI: dremio+flight://admin:admin123@dremio:32010
   
   Test connection: ✅ Succès
   ```

3. **Haga clic en "Conectar"**

### Crear un conjunto de datos

1. **Navegue a Conjuntos de datos**
   - Haga clic en "Datos" → "Conjuntos de datos"
   - Haga clic en "+ Conjunto de datos"

2. **Configurar el conjunto de datos**
   ```yaml
   Database: Dremio Lakehouse
   Schema: @admin.marts
   Table: fct_customer_orders
   ```

3. **Haga clic en "Crear conjunto de datos y crear gráfico"**

### Crear gráficos

#### Gráfico 1: Segmentos de clientes (Diagrama circular)

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

#### Gráfico 2: Ingresos por país (Gráfico de barras)

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

#### Gráfico 3: Métricas de clientes (gran cantidad)

```yaml
Chart Type: Big Number
Datasource: fct_customer_orders

Metric: COUNT(DISTINCT customer_id)
Subheader: Total Clients

Chart Options:
  Number Format: ,d
```

### Crear el panel

1. **Navegue a Paneles**
   - Haga clic en "Paneles"
   - Haga clic en "+ Panel de control"

2. **Configurar el panel**
   ```yaml
   Title: Analytique Clients
   Slug: customer-analytics
   Owners: admin
   Published: Yes
   ```

3. **Agregar gráficos**
   - Arrastra y suelta los gráficos creados.
   - Organizar en una cuadrícula:
     ```
     [ Total Clients      ]
     [ Segments ] [ Revenu par Pays ]
     ```

4. **Agregar filtros** (opcional)
   - Haga clic en "Agregar filtro"
   - Filtrar por: código_país
   - Aplicar a todos los gráficos.

5. **Guarde el panel**

---

## Paso 8: Verifique el proceso completo

### Pruebas de un extremo a otro

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

### Agregar nuevos datos

1. **Insertar nuevos registros en PostgreSQL**
   ```sql
   docker exec -it postgres psql -U postgres -d dremio_db
   
   INSERT INTO customers (name, email, country) VALUES
       ('Emma Wilson', 'emma@example.com', 'USA'),
       ('Li Wei', 'li@example.com', 'China');
   
   INSERT INTO orders (customer_id, amount, status) VALUES
       (6, 500.00, 'completed'),
       (7, 350.00, 'pending');
   ```

2. **Activar sincronización de Airbyte**
   - Abre la interfaz de Airbyte
   - Ir a la conexión "PostgreSQL → MinIO"
   - Haga clic en "Sincronizar ahora"
   - Espera el final ✅

3. **Ejecute dbt**
   ```bash
   cd dbt
   dbt run
   ```

4. **Actualice el panel Superset**
   - Abre el tablero
   - Haga clic en el botón "Actualizar"
   - Deberían aparecer nuevos datos ✅

### Verificar flujo de datos

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

## Paso 9: Automatizar la canalización

### Programar sincronización de Airbyte

Ya configurado para ejecutarse cada 24 horas a las 02:00.

Para editar:
1. Abrir conexión en Airbyte
2. Vaya a la pestaña "Configuración"
3. Actualice "Frecuencia de replicación"
4. Guardar

### Programar ejecuciones de dbt

**Opción 1: Trabajo cron (Linux)**
```bash
# Éditer crontab
crontab -e

# Ajouter exécution dbt à 2h30 quotidiennement (après sync Airbyte)
30 2 * * * cd /path/to/dremiodbt/dbt && /path/to/venv/bin/dbt run >> /var/log/dbt.log 2>&1
```

**Opción 2: secuencia de comandos Python**

**Archivo**: `scripts/run_pipeline.py`
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

### Programar con Docker Compose

**Archivo**: `docker-compose.scheduler.yml`
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

## Próximos pasos

¡Felicidades! Ha creado una canalización de datos completa de un extremo a otro. 🎉

### Más información

1. **Airbyte Advanced** - [Guía de integración de Airbyte](../guides/airbyte-integration.md)
2. **Optimización de Dremio** - [Guía de configuración de Dremio](../guides/dremio-setup.md)
3. **Modelos dbt complejos** - [Guía de desarrollo de dbt](../guides/dbt-development.md)
4. **Paneles de control avanzados** - [Guía de paneles de control Superset](../guides/superset-dashboards.md)
5. **Calidad de datos** - [Guía de calidad de datos](../guides/data-quality.md)

### Solución de problemas

Si tiene problemas, consulte:
- [Guía de solución de problemas](../guides/troubleshooting.md)
- [Guía de instalación](installation.md#troubleshooting)
- [Guía de configuración] (configuration.md)

---

## Resumen

Has conseguido con éxito:

- ✅ Accede a los 7 servicios de la plataforma
- ✅ Configurar una fuente Airbyte (PostgreSQL)
- ✅ Configurar un destino Airbyte (MinIO S3)
- ✅ Crea tu primera conexión Airbyte
- ✅ Conecte Dremio a MinIO
- ✅ Crear plantillas dbt (puesta en escena + marts)
- ✅ Cree un panel de control de superconjunto
- ✅ Verifique el flujo de datos de un extremo a otro
- ✅ Automatizar la ejecución del pipeline

**¡Tu plataforma de datos ya está operativa!** 🚀

---

**Versión de la Guía de Primeros Pasos**: 3.2.0  
**Última actualización**: 2025-10-16  
**Mantenido por**: Equipo de plataforma de datos