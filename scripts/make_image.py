from pathlib import Path
import argparse
import base64

from GenAI.clients.openai_client import openai_client


def main():
    p = argparse.ArgumentParser(description="Generar imagen con OpenAI (gpt-image-1)")
    p.add_argument("--prompt", default="Un gato cibernetico, luz neon azul, fondo oscuro")
    p.add_argument("--size", default="1024x1024", choices=["256x256", "512x512", "1024x1024", "2048x2048"])
    p.add_argument("--out", default="gato.png")
    args = p.parse_args()

    client = openai_client()
    r = client.images.generate(model="gpt-image-1", prompt=args.prompt, size=args.size)
    b64 = r.data[0].b64_json
    out = Path(args.out).resolve()
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_bytes(base64.b64decode(b64))
    print(f"Imagen generada en: {out}")


if __name__ == "__main__":
    main()
