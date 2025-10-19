import base64
from io import BytesIO
from pathlib import Path
from PIL import Image


def save_openai_base64_png(b64_json: str, out: Path) -> Path:
    data = base64.b64decode(b64_json)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_bytes(data)
    return out


def save_gemini_inline_png(resp, out: Path) -> Path:
    for c in getattr(resp, "candidates", []) or []:
        content = getattr(c, "content", None)
        parts = getattr(content, "parts", []) if content else []
        for part in parts:
            if getattr(part, "inline_data", None):
                img = Image.open(BytesIO(part.inline_data.data))
                out.parent.mkdir(parents=True, exist_ok=True)
                img.save(out)
                return out
    raise RuntimeError("No image found in Gemini response")

