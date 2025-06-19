FROM ubuntu:22.04

RUN apt update && apt install -y \
    build-essential cmake ffmpeg curl git python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY app.py .
COPY models/ models/
COPY whisper.cpp/ whisper.cpp/

EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
