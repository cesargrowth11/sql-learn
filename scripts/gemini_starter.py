import argparse, json
from pathlib import Path
from io import BytesIO
from PIL import Image

from GenAI.clients.gemini_client import gemini_client


def run_text(model: str, prompt: str):
    gem = gemini_client()
    r = gem.models.generate_content(model=model, contents=prompt)
    print(r.text)


def run_json(model: str, prompt: str):
    from google.genai import types

    gem = gemini_client()
    r = gem.models.generate_content(
        model=model,
        contents=prompt,
        config=types.GenerateContentConfig(response_mime_type="application/json"),
    )
    try:
        data = json.loads(r.text)
        print(json.dumps(data, ensure_ascii=False, indent=2))
    except Exception:
        print(r.text)


def run_image(model: str, prompt: str, out: Path):
    gem = gemini_client()
    r = gem.models.generate_content(model=model, contents=[prompt])
    for c in r.candidates:
        for part in c.content.parts:
            if getattr(part, "inline_data", None):
                img = Image.open(BytesIO(part.inline_data.data))
                img.save(out)
                print(f"Imagen guardada en: {out}")
                return
    raise RuntimeError("No se encontró imagen en la respuesta")


def main():
    p = argparse.ArgumentParser(description="Gemini starter (text/json/image)")
    p.add_argument("--mode", choices=["text", "json", "image"], default="text")
    p.add_argument("--model", default="gemini-2.5-flash")
    p.add_argument("--prompt", required=True)
    p.add_argument("--out", default="gemini_image.png")
    args = p.parse_args()

    if args.mode == "text":
        run_text(args.model, args.prompt)
    elif args.mode == "json":
        run_json(args.model, args.prompt)
    else:
        run_image(args.model, args.prompt, Path(args.out))


if __name__ == "__main__":
    main()

