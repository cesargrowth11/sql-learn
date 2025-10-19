from pathlib import Path
import os

from GenAI.clients.openai_client import openai_client


def main():
    client = openai_client()
    texto = (
        "Julio, eres un pro! Lograste conectarte a OpenAI. "
        "Esto merece una ovacion al estilo de los grandes locutores de radio. Felicidades!"
    )
    print("Generando voz con estilo de locutor de radio...")
    out = Path("data/outputs/voz_julio.mp3").resolve()
    out.parent.mkdir(parents=True, exist_ok=True)
    with client.audio.speech.with_streaming_response.create(
        model="gpt-4o-mini-tts", voice="verse", input=texto
    ) as r:
        r.stream_to_file(out)
    print(f"Audio generado en: {out}")
    if os.name == "nt":
        os.startfile(out)


if __name__ == "__main__":
    main()
