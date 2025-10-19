from dotenv import load_dotenv, find_dotenv
from pathlib import Path
import os

# Load nearest .env once on import (does not override existing env vars)
_loaded = load_dotenv(find_dotenv(usecwd=True), override=False)
# Fallback: try repo_root/GenAI/.env if not found
if not _loaded:
    try:
        repo_root = Path.cwd()
        alt = repo_root / "GenAI" / ".env"
        if alt.exists():
            load_dotenv(alt, override=False)
    except Exception:
        pass


def require(var: str) -> str:
    value = os.getenv(var)
    if not value:
        raise RuntimeError(f"Missing required environment variable: {var}")
    return value
