# Containerfile.xinoxano — Imatge base sandbox
# Xino xano: àgil, discret, lleuger
# Basat en arch-base-privileged + uv
# ============================================================

FROM ghcr.io/drmicalet/arch-base-privileged:latest

LABEL maintainer="drmicalet <m00mayoltur@gmail.com>"
LABEL description="Base sandbox amb uv — Xino xano, àgil i discret. Imatge base per a experiments, desenvolupament i proves."
LABEL version="1.0"
LABEL org.opencontainers.image.source="https://github.com/Drmicalet/xinoxano"
LABEL org.opencontainers.image.title="xinoxano"
LABEL org.opencontainers.image.description="Arch Linux privileged base + uv sandbox"

# Actualitzar sistema i instal·lar uv + git
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm --needed \
        uv git python vim curl wget jq && \
    pacman -Scc --noconfirm

# Directoris del sandbox
RUN mkdir -p /opt/sandbox/{projects,venvs,logs,bin} && \
    chown -R builder:builder /opt/sandbox

WORKDIR /opt/sandbox

# Per defecte: bash interactiva (per a kubectl exec -it)
CMD ["/usr/bin/bash"]