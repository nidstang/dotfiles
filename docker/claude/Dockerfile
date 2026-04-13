FROM node:22.15.0-slim

# Instalar dependencias esenciales de sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    make \
    && rm -rf /var/lib/apt/lists/*

# Instalar la CLI de Claude Code globalmente
RUN npm install -g pnpm@10.11.0 @anthropic-ai/claude-code

# Crear usuario no-root para poder usar --dangerously-skip-permissions
RUN useradd -m -d /tmp/home -s /bin/bash claude-user \
    && mkdir -p /workspace \
    && chown claude-user:claude-user /workspace

# Crear y configurar el directorio de trabajo
WORKDIR /workspace

COPY --chown=claude-user:claude-user ./.claude.json /tmp/home/.claude.json

USER claude-user

# El punto de entrada será el binario de claude
ENTRYPOINT ["claude"]
