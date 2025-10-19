from pathlib import Path
from dotenv import load_dotenv, find_dotenv, dotenv_values
import os


def main():
    here = Path(__file__).resolve().parent
    dotenv_path = Path(find_dotenv(usecwd=True))
    print("Script en      :", here)
    print(".env resuelto  :", dotenv_path)
    print("¿existe .env?  :", dotenv_path and Path(dotenv_path).exists())

    if dotenv_path and Path(dotenv_path).exists():
        head = Path(dotenv_path).read_text(encoding="utf-8", errors="ignore").splitlines()[:5]
        print("Primeras lineas del .env:")
        for i, line in enumerate(head, 1):
            print(f"   {i:02d}: {line}")

    loaded = load_dotenv(dotenv_path, override=True)
    print("load_dotenv ->", loaded)

    env_openai = os.getenv("OPENAI_API_KEY")
    env_gemini = os.getenv("GEMINI_API_KEY")
    print("OPENAI_API_KEY empieza con:", (env_openai or "")[:10])
    print("GEMINI_API_KEY empieza con:", (env_gemini or "")[:10])

    if not env_gemini:
        vals = dotenv_values(dotenv_path)
        print("dotenv_values keys:", list(vals.keys()))
        env_gemini = vals.get("GEMINI_API_KEY")
        if env_gemini:
            print("Leida manualmente GEMINI_API_KEY (len):", len(env_gemini))
            os.environ["GEMINI_API_KEY"] = env_gemini

    if not os.getenv("GEMINI_API_KEY"):
        raise RuntimeError("No encontre GEMINI_API_KEY. Revisa el archivo .env")

    from GenAI.clients import gemini_client as g

    client = g.gemini_client()
    resp = client.models.generate_content(
        model="gemini-2.5-flash", contents="Responde OK"
    )
    print("Gemini dijo:", resp.text)


if __name__ == "__main__":
    main()

