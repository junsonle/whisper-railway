from flask import Flask, request, jsonify
from faster_whisper import WhisperModel
import tempfile
import os
import io
import sys

app = Flask(__name__)
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Load model sẵn (dùng tiny để nhẹ và nhanh hơn)
model = WhisperModel("tiny", compute_type="int8", device="cpu")

@app.route("/transcribe", methods=["POST"])
def transcribe():
    if 'audio' not in request.files:
        return jsonify({"error": "Thiếu file audio"}), 400

    file = request.files['audio']

    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as tmp:
        file_path = tmp.name
        file.save(file_path)

    try:
        segments, _ = model.transcribe(file_path, language="vi")
        text = " ".join([seg.text for seg in segments])
        return jsonify({"text": text})
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if os.path.exists(file_path):
            os.remove(file_path)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))
