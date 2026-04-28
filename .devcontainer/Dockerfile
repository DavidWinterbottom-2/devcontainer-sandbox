# Base image — Debian slim with common dev tools pre-installed
FROM mcr.microsoft.com/devcontainers/base:bullseye

# ── System packages ──────────────────────────────────────────────────────────
# Add or remove packages here to suit your sandpit needs
RUN apt-get update && apt-get install -y --no-install-recommends \
    # General utilities
    curl \
    wget \
    git \
    unzip \
    zip \
    jq \
    tree \
    htop \
    vim \
    make \
    # Build tools
    build-essential \
    pkg-config \
    # Python
    python3 \
    python3-pip \
    python3-venv \
    # Node.js (via NodeSource)
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    # SSH client for ssh-agent
    openssh-client \
    # Clean up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ── Node.js global tools ─────────────────────────────────────────────────────
RUN npm install -g \
    pnpm \
    typescript \
    ts-node \
    nodemon

# ── Python global tools ───────────────────────────────────────────────────────
RUN pip3 install --no-cache-dir \
    ipython \
    httpx \
    requests \
    rich

# ── SDKMAN + JVM languages (optional — comment out the block to remove) ──────
# SDKMAN manages Java, Scala, Kotlin, Groovy, sbt, Maven, Gradle, etc.
# Default versions are installed below; swap them at runtime with:
#   sdk install java 21-tem
#   sdk install scala 3.4.2
#   sdk list java          ← browse available versions
USER vscode
ENV SDKMAN_DIR="/home/vscode/.sdkman"
RUN curl -s "https://get.sdkman.io" | bash \
    && bash -c "source ${SDKMAN_DIR}/bin/sdkman-init.sh \
    && sdk install java 21.0.3-tem \
    && sdk install scala \
    && sdk install sbt \
    && sdk flush archives"
USER root

# ── Go (optional — comment out if not needed) ────────────────────────────────
ARG GO_VERSION=1.22.3
RUN curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    | tar -C /usr/local -xzf -
ENV PATH="/usr/local/go/bin:${PATH}"

# ── Rust (optional — comment out if not needed) ──────────────────────────────
USER vscode
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --default-toolchain stable
ENV PATH="/home/vscode/.cargo/bin:${PATH}"
USER root

# ── Shell tweaks ──────────────────────────────────────────────────────────────
COPY .devcontainer/.bashrc-extra /tmp/.bashrc-extra
RUN cat /tmp/.bashrc-extra >> /home/vscode/.bashrc

# Default to vscode user (non-root)
USER vscode
