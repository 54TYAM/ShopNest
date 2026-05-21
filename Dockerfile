FROM python:3.11-slim
WORKDIR /app
COPY . /app
RUN apt-get update && apt-get install -y build-essential git && rm -rf /var/lib/apt/lists/*
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
ENV API_HOST=0.0.0.0
ENV API_PORT=8000
CMD ["bash","-lc","export API_PORT=${PORT:-8000} && uvicorn src.api.main:app --host 0.0.0.0 --port ${API_PORT}"]
