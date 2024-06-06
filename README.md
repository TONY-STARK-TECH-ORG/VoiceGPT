```shell
sudo docker pull starkdylan/voicegpt.chat:latest
sudo docker compose up -d
```

```docker
version: '3.8'
services:
  fast-gpt:
    image: "starkdylan/voicegpt.chat:latest"
    container_name: "voice-gpt"
    restart: always
    enviroment:
      LIVEKIT_URL: ""
      LIVEKIT_API_KEY: ""
      LIVEKIT_API_SECRET: ""
      OPENAI_API_KEY: ""
```