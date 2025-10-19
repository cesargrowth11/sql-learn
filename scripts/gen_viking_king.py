from pathlib import Path
from google.genai import types

from GenAI.clients.gemini_client import gemini_client
from GenAI.utils.image import save_gemini_inline_png


def main():
    import argparse

    p = argparse.ArgumentParser(description="Generar retrato realista de un rey vikingo (Gemini)")
    p.add_argument("--model", default="gemini-2.5-flash-image")
    p.add_argument("--out", default="vikingo_rey.png")
    p.add_argument("--seed", type=int, default=None)
    args = p.parse_args()

    prompt = """
Ultra-realistic portrait photo of a Viking king inspired by legendary Ragnar:
- Age ~40s, Nordic features, intense blue-gray eyes, weathered sun-and-sea skin
- Thick braided beard with small bronze beads; undercut hair pulled back
- Crown: hammered iron circlet with Norse knotwork (no gems), battle-worn
- Wardrobe: dark wool tunic, heavy gray fur cloak, leather pauldrons, iron brooch
- Accessories: runic ring, simple leather necklace, faint battle scars on cheek
- Scene: cold coastal fjord at dusk; snow flurries in air; longship bokeh behind
- Lighting: dramatic Rembrandt studio look + faint rim light from left
- Camera: full-frame, 85mm lens, f/1.8, shallow depth of field, crisp skin detail
- Color: cinematic, desaturated blues and steel grays; high dynamic range
- Mood: stoic, regal, fearless; gaze slightly off-camera
- Photo realism, 4k, high detail, sharp focus
-- Do not include text, captions, logos, or watermarks.
"""

    gem = gemini_client()
    cfg = types.GenerateContentConfig()
    if args.seed is not None:
        cfg.seed = args.seed
    resp = gem.models.generate_content(model=args.model, contents=[prompt], config=cfg)

    out = Path(args.out).resolve()
    save_gemini_inline_png(resp, out)
    print(f"Imagen generada: {out}")


if __name__ == "__main__":
    main()

