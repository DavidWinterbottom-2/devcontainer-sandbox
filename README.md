# 🧪 Devcontainer Sandbox

A minimal, ready-to-go VS Code devcontainer for ad-hoc sandpits.  
Clone it, open in VS Code, and you have a full Linux dev environment — no local installs needed beyond Docker Desktop.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) running
- [VS Code](https://code.visualstudio.com/) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Getting started

```bash
git clone https://github.com/YOUR_USERNAME/devcontainer-sandbox.git
code devcontainer-sandbox
# VS Code will prompt: "Reopen in Container" → click it
```

The first build takes a few minutes while Docker pulls the base image and installs tools. Subsequent opens are fast (the image is cached).

## What's included

| Layer | Tools |
|---|---|
| Base | Debian Bullseye, git, curl, wget, jq, make, vim |
| Python | python3, pip, venv, ipython, httpx, rich |
| Node.js | Node 20, npm, pnpm, TypeScript, ts-node, nodemon |
| Go | Go 1.22 (comment out in Dockerfile to remove) |
| Rust | stable toolchain via rustup (comment out to remove) |
| VS Code | Python, ESLint, Prettier, TypeScript, Go, Rust, Docker, GitLens |

## Customising

### Add system packages
Edit `.devcontainer/Dockerfile` — find the `apt-get install` block and add what you need.

### Add Python packages globally
Add to the `pip3 install` block in the Dockerfile.

### Add Node global tools
Add to the `npm install -g` block in the Dockerfile.

### Remove a language runtime
Comment out the Go or Rust section in the Dockerfile to keep the image lean.

### Project-level deps
Drop a `requirements.txt` or `package.json` in the repo root — `post-create.sh` will install them automatically on first container start.

### Change forwarded ports
Edit `forwardPorts` in `.devcontainer/devcontainer.json`.

## Sandpit workflow

```
sandbox/
├── scratch.py       # Python experiments
├── scratch.ts       # TypeScript experiments  
├── scratch.go       # Go experiments
└── notes.md         # Running notes
```

The `sandbox/` folder is gitignored by default so your experiments don't pollute commits.

## Rebuilding the container

If you change the Dockerfile or devcontainer.json, run:

> **Ctrl/Cmd + Shift + P** → `Dev Containers: Rebuild Container`
