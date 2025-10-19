from openai import OpenAI as OpenAIClient
from GenAI.config.env import require
import os


def openai_client() -> OpenAIClient:
    key = require("OPENAI_API_KEY")
    org = os.getenv("OPENAI_ORG_ID")
    return OpenAIClient(api_key=key, organization=org) if org else OpenAIClient(api_key=key)

