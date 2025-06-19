from fastapi import FastAPI, UploadFile, File
from fastapi.responses import JSONResponse
import subprocess
import os

app = FastAPI()

@app.post("/transcribe")
async def transcribe(audio: UploadFile = File(...)):
    input_path = f"/tmp/{audio.filename}"
    output_path = input_path + ".txt"

    with open(input_path, "wb") as f:
        f.write(await audio.read())

    subprocess.run([
        "./whisper.cpp/main",
        "-m", "models/ggml-small.bin",
        "-f", input_path,
        "-l", "vi",
        "-otxt"
    ])

    if os.path.exists(output_path):
        with open(output_path, "r", encoding="utf-8") as f:
            result = f.read().strip()
        return JSONResponse({"text": result})
    return JSONResponse({"error": "No output generated"})