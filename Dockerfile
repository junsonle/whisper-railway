FROM ubuntu:22.04

RUN apt update && apt install -y \
    build-essential cmake ffmpeg curl git python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip3 install -r requirements.txt

RUN git clone https://github.com/ggerganov/whisper.cpp.git
RUN make -C whisper.cpp

RUN mkdir -p models && \
    curl -L -o models/ggml-tiny.bin https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-tiny.bin

COPY app.py .

EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
