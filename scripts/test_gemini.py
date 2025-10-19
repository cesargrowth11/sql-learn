from GenAI.clients.gemini_client import gemini_client


def main():
    client = gemini_client()
    resp = client.models.generate_content(
        model="gemini-2.5-flash", contents="Responde con una sola palabra: OK"
    )
    print(resp.text)


if __name__ == "__main__":
    main()

