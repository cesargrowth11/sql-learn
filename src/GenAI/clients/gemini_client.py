from google import genai as GoogleGenAI
from GenAI.config.env import require


def gemini_client() -> GoogleGenAI.Client:
    key = require("GEMINI_API_KEY")
    return GoogleGenAI.Client(api_key=key)

