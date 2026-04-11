FROM node:22.15.0-slim

# Instalar dependencias esenciales de sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    make \
    && rm -rf /var/lib/apt/lists/*

# Instalar la CLI de OpenCode globalmente
RUN npm install -g pnpm@10.11.0 opencode-ai

# Crear y configurar el directorio de trabajo
WORKDIR /workspace

COPY ./opencode.json /tmp/home/.config/opencode/opencode.json

# El punto de entrada será el binario de opencode
ENTRYPOINT ["opencode"]
