# Telecom Network Data Warehouse - Análisis de eventos de red

Proyecto de ingeniería de datos orientado al procesamiento y análisis de eventos generados por una empresa de telecomunicaciones.

El sistema implementa una arquitectura Medallion (Bronze, Silver y Gold) para transformar datos crudos en información confiable para el análisis de infraestructura de red, comportamiento de clientes y generación de indicadores de negocio.

Python actúa como orquestador del pipeline ETL, encargado de la ingesta y coordinación de procesos.

SQL Server centraliza el almacenamiento, las transformaciones y el modelado analítico del Data Warehouse.

Docker proporciona el entorno de ejecución del sistema (SQL Server + ETL), garantizando portabilidad y consistencia.

---

## Arquitectura

El proyecto implementa una arquitectura Medallion para transformar datos crudos provenientes de eventos de red en información lista para el análisis.

```
Parquet
    │
    ▼
Python (ETL Orquestador en Docker)
    │
    ▼
Bronze
    │
    ▼
Silver
    │
    ▼
Gold
    │
    ├────────► Audit
    │
    ▼
Analytics
```

- **Python:** coordina el pipeline completo, desde la lectura del archivo Parquet hasta la ejecución de los procesos SQL.
- **Bronze:** almacena los datos sin modificaciones.
- **Silver:** aplica reglas de limpieza y transformación.
- **Gold:** implementa el modelo analítico mediante tablas de hechos, dimensiones y vistas.
- **Audit:** trazabilidad del pipeline.
- **Analytics:** contiene las consultas utilizadas para responder preguntas de negocio y calcular indicadores.
---
## Tecnologías

| Tecnología | Propósito |
|------------|----------|
| Python | Orquestación del ETL y carga de datos |
| SQL Server | Almacenamiento y modelado del Data Warehouse |
| Docker | Entorno de ejecución del sistema |

---
## Estructura de carpetas
```` 
Telecom_Network_Data_Warehouse/
│
├── requirements.txt
├── Dockerfile
├── docker-compose.yml
├── README.md
├── .gitignore
│
├──data/
    ├── input/
    ├── processed/
    └── rejected/

├── python/
    ├── config/
        └── database.py
    ├── extract/
    ├── load/
    ├── orchestration/
    ├── logs/
    └── main.py
    
├──sql/
    ├── initialization/
    │   ├──01_create_database.sql
    │   ├──02_create_schemas.sql
    │
    ├── bronze/
    │   └── tables/
    │
    ├── silver/
    │   ├── tables/
    │   ├── rules/
    │   ├── procedures/
    │   └── functions/
    │
    ├── gold/
    │   ├── dimensions/
    │   ├── facts/
    │   ├── views/
    │   ├── procedures/
    │   └── functions/
    │
    ├── audit/
        ├── create_etl_processed_files.sql
        ├── create_etl_pipeline_executions.sql
        └── create_etl_error_logs.sql
    │
    └── analytics/
        ├── business/
            └── business_questions.sql
        ├── kpis/
            └── kpis.sql
        ├── exploration/
            └── ad_hoc_analysis.sql
        
└── docs/
    ├──context.md
    ├──architecture.md
    ├──business_questions.md
    └──business_rules.md
````
### Descripción de la estructura del proyecto

#### `data/`

Contiene los archivos utilizados durante el proceso de ingesta de datos.

* **input/**: carpeta donde se depositan los archivos Parquet pendientes de procesamiento.
* **processed/**: almacena los archivos procesados correctamente para evitar su reprocesamiento.
* **rejected/**: almacena los archivos que no pudieron procesarse debido a errores de formato, integridad o carga.



#### `python/`

Contiene el código responsable de orquestar el pipeline ETL.

* **config/**: configuración de la conexión con SQL Server y parámetros generales del proyecto.
* **extract/**: lectura y validación de los archivos Parquet.
* **load/**: carga de los datos hacia la capa Bronze.
* **orchestration/**: coordina la ejecución del pipeline, definiendo el orden de cada etapa del proceso ETL.
* **logs/**: almacena los registros generados por la ejecución del programa para facilitar el monitoreo y la depuración.
* **main.py**: punto de entrada del proyecto. Inicializa el sistema y ejecuta automáticamente todas las etapas del pipeline.

---

### `sql/`

Contiene todos los scripts SQL utilizados para construir y mantener el Data Warehouse.

##### `initialization/`

Scripts ejecutados únicamente durante la inicialización del sistema.

* **01_create_database.sql**: crea la base de datos del proyecto.
* **02_create_schemas.sql**: crea los esquemas Bronze, Silver, Gold y Audit.



##### `bronze/`

Define la primera capa de la arquitectura Medallion.

* **tables/**: scripts que crean las tablas donde se almacenan los datos exactamente como fueron recibidos, sin aplicar ninguna transformación.



##### `silver/`

Implementa la limpieza y estandarización de los datos.

* **tables/**: creación de las tablas limpias que almacenarán la información transformada.
* **rules/**: reglas de limpieza, validación y transformación de los datos provenientes de Bronze.
* **procedures/**: procedimientos almacenados que automatizan la carga y transformación hacia Silver.
* **functions/**: funciones reutilizables utilizadas durante el proceso de transformación.



##### `gold/`

Implementa el modelo analítico del Data Warehouse.

* **dimensions/**: scripts que crean las tablas de dimensiones del modelo estrella.
* **facts/**: scripts que crean las tablas de hechos con las métricas del negocio.
* **views/**: vistas orientadas al consumo de información por analistas y reportes.
* **procedures/**: procedimientos almacenados para poblar las tablas de hechos y dimensiones.
* **functions/**: funciones auxiliares utilizadas por los procesos analíticos.


##### `audit/`

Contiene los objetos encargados de registrar la ejecución del pipeline ETL.

* **create_etl_processed_files.sql**: crea la tabla que registra todos los archivos procesados, evitando cargas duplicadas.
* **create_etl_pipeline_executions.sql**: crea la tabla que almacena el historial de ejecuciones completas del pipeline ETL.
* **create_etl_error_logs.sql**: crea la tabla que registra los errores ocurridos durante el procesamiento de archivos o la ejecución del pipeline.


##### `analytics/`

Contiene consultas SQL orientadas al análisis del negocio. Estas consultas no modifican los datos del Data Warehouse; únicamente consumen la información almacenada en Gold.

* **business/**: consultas que responden las preguntas de negocio planteadas para el proyecto.
* **kpis/**: consultas utilizadas para calcular indicadores clave de desempeño (KPIs).
* **exploration/**: consultas exploratorias y análisis ad hoc utilizados durante el desarrollo o la investigación de datos.



#### `docs/`

Documentación funcional y técnica del proyecto.

* **context.md**: descripción del problema de negocio y contexto de la empresa.
* **architecture.md**: explicación de la arquitectura del sistema, el pipeline ETL y el flujo de datos.
* **business_questions.md**: conjunto de preguntas de negocio que el Data Warehouse debe ser capaz de responder.
* **business_rules.md**: reglas de negocio y criterios de transformación aplicados durante el procesamiento de los datos.

---
## Cómo ejecutar

1. Clonar el repositorio.

2. Levantar todo el entorno (SQL Server + ETL):

```bash
docker compose up --build -d 
```
Esto iniciará automáticamente:
- SQL Server
- Pipeline ETL en Python
    
3. Colocar uno o más archivos `.parquet` dentro de:

```
data/input/
```

El pipeline se ejecuta dentro de Docker y procesará automáticamente todos los archivos `.parquet`


Para cada archivo, ejecutará las siguientes etapas:

1. Inicializar la base de datos (si no existe).
2. Crear los esquemas y tablas necesarios (si no existe).
3. Cargar los datos en la capa Bronze.
4. Ejecutar las transformaciones hacia Silver.
5. Construir el modelo analítico en Gold.
6. Registrar la ejecución en las tablas de auditoría.

Cada archivo será procesado de manera independiente.

- Si el procesamiento finaliza correctamente, el archivo será movido a `data/processed/`
- Si ocurre algún error, el archivo será movido a `data/rejected/`.
- Los archivos previamente procesados serán identificados mediante las tablas de auditoría para evitar cargas duplicadas.
- Un error durante el procesamiento de un archivo no detendrá el procesamiento de los archivos restantes.

