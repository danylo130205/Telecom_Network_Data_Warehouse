# Definir la versión de python a usar
FROM python:3.11-slim

# Evita buffering de logs
ENV PYTHONUNBUFFERED=1

# Definir donde se va a alojar el proeycto dentro de docker
WORKDIR /app

# Instalar dependencias del sistema (CRÍTICO para pyodbc)
RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    g++ \
    gnupg \
    unixodbc \
    unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalar Microsoft ODBC Driver 18
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg && \
    curl https://packages.microsoft.com/config/debian/12/prod.list \
    -o /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 && \
    rm -rf /var/lib/apt/lists/*

# Copiamos os requerimeintos
COPY requirements.txt .

# Instalar todas las dependencias definidas en el requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el proyecto
COPY python/ ./python
COPY sql/ ./sql


# Definir metodo de arrance mediante docker run
CMD ["python","python/main.py"]