FROM ubuntu:22.04

# Cài các thư viện cần thiết
RUN apt update && apt install -y \
    build-essential cmake ffmpeg curl git python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Tạo thư mục làm việc
WORKDIR /app

# Cài Python requirements
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Clone whisper.cpp và build
RUN git clone https://github.com/ggerganov/whisper.cpp.git
RUN make -C whisper.cpp

# Tải model
RUN mkdir -p models && \
    curl -L -o models/ggml-tiny.bin https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small.bin

# Copy file app
COPY app.py .

# Chạy API
EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
