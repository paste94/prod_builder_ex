FROM python:3.12-slim

WORKDIR /app

# Installa dipendenze
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia il codice
COPY app ./app
COPY tests ./tests

# Espone la porta (Railway usa $PORT)
ENV PORT=8000
EXPOSE 8000

# Avvia uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]