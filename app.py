import os
import subprocess
from fastapi import FastAPI, UploadFile, File
from fastapi.responses import JSONResponse

app = FastAPI()

@app.post("/transcribe")
async def transcribe(audio: UploadFile = File(...)):
    input_path = "audio.wav"
    output_path = "audio.wav.txt"

    with open(input_path, "wb") as f:
        f.write(await audio.read())

    result = subprocess.run([
        "./whisper.cpp/main",
        "-m", "models/ggml-tiny.bin",
        "-f", input_path,
        "-l", "vi",
        "-otxt"
    ], capture_output=True, text=True)

    if not os.path.exists(output_path):
        return JSONResponse({"error": "Transcription failed", "stderr": result.stderr}, status_code=500)

    with open(output_path, "r", encoding="utf-8") as f:
        text = f.read()

    return {"text": text}
