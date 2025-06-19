# ✅ 1. Base image
FROM ubuntu:22.04

# ✅ 2. Cài đặt hệ thống và Python
RUN apt update && apt install -y \
    build-essential cmake ffmpeg curl git python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# ✅ 3. Cài Python requirements
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# ✅ 4. Clone whisper.cpp & build
RUN git clone https://github.com/ggerganov/whisper.cpp.git
RUN make -C whisper.cpp

# ✅ 5. Tải model tiny
RUN mkdir -p /app/models && \
    curl -L -o /app/models/ggml-tiny.bin https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small.bin

# ✅ 6. Copy mã nguồn ứng dụng
COPY app.py .

# ✅ 7. Mở cổng 8000
EXPOSE 8000

# ✅ 8. Lệnh chạy FastAPI
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
