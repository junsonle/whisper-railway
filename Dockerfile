RUN apt update && apt install -y \
    build-essential cmake ffmpeg curl git python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Clone whisper.cpp từ GitHub thay vì COPY
RUN git clone https://github.com/ggerganov/whisper.cpp.git

# Tải model
RUN mkdir -p /app/models && \
    curl -L -o /app/models/ggml-tiny.bin https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small.bin

# Build whisper.cpp
RUN make -C whisper.cpp

# Copy app source
COPY app.py requirements.txt ./
RUN pip3 install -r requirements.txt

EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
