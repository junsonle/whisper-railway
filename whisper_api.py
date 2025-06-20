from flask import Flask, request, jsonify
from faster_whisper import WhisperModel
import os
import io
import sys

app = Flask(__name__)

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
model = WhisperModel("small", compute_type="int8", device="cpu")

@app.route("/transcribe", methods=["POST"])
def transcribe():
    if 'audio' not in request.files:
        return jsonify({"error": "Thiếu file audio"}), 400

    file = request.files['audio']
    file_path = "temp.wav"
    file.save(file_path)

    try:
        segments, _ = model.transcribe(file_path, language="vi")
        text = " ".join([seg.text for seg in segments])
        return jsonify({"text": text})
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        os.remove(file_path)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))

