# GenAI Lab — Apps y Scripts para Contenidos con OpenAI y Gemini

GenAI Lab es un conjunto de utilidades y una API mínima para generar contenidos con OpenAI y Google Gemini: textos, imágenes y audio TTS. El objetivo es ofrecer un punto de partida profesional, extensible y seguro para experimentación y prototipado en proyectos creativos.

## Características

- API FastAPI lista para usar con endpoints:
  - `POST /brief`: genera un “creative brief” en JSON y (opcional) exporta DOCX.
  - `POST /tts`: sintetiza voz (TTS) y guarda un `.mp3`.
  - `POST /image`: genera imágenes con OpenAI o Gemini y guarda un `.png`.
  - `GET /download`: descarga de archivos limitada al directorio de salidas.
- Scripts CLI para tareas comunes:
  - `scripts/make_image.py` (OpenAI) y `scripts/gen_viking_king.py` (Gemini)
  - `scripts/radio_voice.py` (TTS OpenAI)
  - `scripts/gen_doc.py` (documento DOCX con GPT)
- Manejo centralizado de variables de entorno (`src/GenAI/config/env.py`).
- Salidas locales consolidadas en `data/outputs/`.
- Layout de paquete en `src/` y editable install con `pyproject.toml`.

## Requisitos

- Python 3.10+
- Claves de API:
  - OpenAI: `OPENAI_API_KEY` (y opcional `OPENAI_ORG_ID`)
  - Gemini: `GEMINI_API_KEY`

## Estructura del proyecto

```
.
├─ src/GenAI/
│  ├─ app/app.py                 # FastAPI app y endpoints
│  ├─ clients/
│  │  ├─ openai_client.py        # Cliente OpenAI (lee .env central)
│  │  └─ gemini_client.py        # Cliente Gemini (lee .env central)
│  ├─ config/env.py              # Carga robusta de .env (find_dotenv + fallback)
│  └─ utils/image.py             # Helpers para guardar imágenes
├─ scripts/
│  ├─ make_image.py              # Imagen con OpenAI
│  ├─ radio_voice.py             # TTS con OpenAI
│  ├─ gen_doc.py                 # DOCX con GPT
│  ├─ gen_viking_king.py         # Imagen con Gemini (ejemplo)
│  ├─ gemini_starter.py          # Starter text/json/image Gemini
│  ├─ test_gemini.py             # Smoke test de Gemini
│  └─ test2.py                   # Diagnóstico de .env
├─ data/outputs/                 # Salidas locales (se crea en runtime)
├─ GenAI/.env                    # Opción frecuente para ubicar .env
├─ .env.example                  # Plantilla segura para variables
├─ requirements.txt              # Dependencias principales
└─ pyproject.toml                # Editable install (src layout)
```

## Configuración de entorno

1) Crea tu archivo `.env` (no se versiona):

```
cp .env.example GenAI/.env
# Edita con tus claves reales
```

Variables admitidas:
- `OPENAI_API_KEY=...`
- `OPENAI_ORG_ID=...` (opcional)
- `GEMINI_API_KEY=...`

El cargador (`src/GenAI/config/env.py`) busca primero con `find_dotenv(usecwd=True)` y, si no encuentra nada, intenta `GenAI/.env` en la raíz del repo.

## Instalación

Con entorno virtual activado:

```
pip install -r requirements.txt
pip install -e .
```

## Ejecutar la API

```
uvicorn GenAI.app.app:app --reload
```

Salidas generadas por la API se guardan en `data/outputs/`.

### Endpoints

- `POST /brief`
  - Body (JSON): parámetros opcionales; por defecto rellenará un brief completo.
  - Respuesta: `{ "brief": { ... }, "docx_path"?: "..." }`
  - Ejemplo rápido (PowerShell):
    ```
    curl -Method Post -Uri http://localhost:8000/brief -Body '{}' -ContentType 'application/json'
    ```

- `POST /tts`
  - Body: `{ "text": "Hola Julio...", "voice": "verse", "filename": "voz.mp3" }`
  - Respuesta: `{ "file": "data/outputs/voz.mp3" }`

- `POST /image`
  - Body: `{ "prompt": "...", "size": "1024x1024", "provider": "openai|gemini", "filename": "image.png" }`
  - Respuesta: `{ "file": "data/outputs/image.png", "provider": "openai|gemini" }`
  - Nota OpenAI: tamaños válidos actuales: `1024x1024`, `1024x1536`, `1536x1024`, `auto`.

- `GET /download?path=archivo`
  - Descarga archivos únicamente desde `data/outputs/` (protegido contra path traversal).

## Scripts (CLI)

Ejemplos:

- Imagen con OpenAI:
  ```
  python scripts/make_image.py --prompt "Gato cibernetico, luz neon azul, fondo oscuro" \
    --size 1024x1024 --out data/outputs/test_openai.png
  ```

- Imagen con Gemini:
  ```
  python scripts/gen_viking_king.py --model gemini-2.5-flash-image --out data/outputs/vikingo.png
  ```

- TTS con OpenAI:
  ```
  python scripts/radio_voice.py
  ```

- DOCX con GPT:
  ```
  python scripts/gen_doc.py
  ```

## Seguridad y buenas prácticas

- `.env`, `*.env` y `data/outputs/` están ignorados en Git (ver `.gitignore`).
- Usa `.env.example` como plantilla, no compartas tus claves reales.
- Los endpoints de descarga validan rutas para evitar accesos fuera de `data/outputs/`.

## Solución de problemas (FAQ)

- `ModuleNotFoundError: No module named 'dotenv'` o similar
  - Ejecuta `pip install -r requirements.txt` en el mismo intérprete que usa tu editor/terminal.

- `Missing required environment variable: OPENAI_API_KEY/GEMINI_API_KEY`
  - Verifica la ubicación de `.env` y su contenido; recuerda que el cargador intenta `find_dotenv` y `GenAI/.env`.

- `openai.BadRequestError: size invalid`
  - Usa tamaños soportados por imágenes OpenAI: `1024x1024`, `1024x1536`, `1536x1024`, `auto`.

- UnicodeEncodeError en Windows (consola)
  - Evita emojis en prints o usa `chcp 65001` antes de ejecutar para salida UTF‑8.

- `billing_hard_limit_reached` (OpenAI)
  - Ajusta el “Monthly Hard Limit” o agrega método de pago en la cuenta.

## Roadmap (ideas)

- Validación y tipado de configuración con `pydantic-settings`.
- Gestión de colas y jobs para procesos más largos.
- Frontend ligero (Streamlit/Gradio) para demos rápidas.
- Pruebas automatizadas de endpoints.

---

¿Sugerencias o mejoras? Abre un issue o propone un PR.

