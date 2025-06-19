FROM ubuntu:22.04

RUN apt update && apt install -y \
    build-essential cmake ffmpeg curl git python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/ggerganov/whisper.cpp
RUN mkdir -p /app/models && \
    curl -L -o /app/models/ggml-small.bin https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small.bin
COPY app.py requirements.txt /app/

RUN pip3 install -r requirements.txt
RUN make -C whisper.cpp

EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]