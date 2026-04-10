# Tools & customisation cheatsheet

You don't need to rebuild the container to install new tools.  
Most things can be added on-demand inside the running container and are ready in seconds.

---

## On-demand vs baked-in

| Approach | How | Persists after rebuild? | When to use |
|---|---|---|---|
| **On-demand** | Install inside the running container | ❌ No | Quick experiments, one-off sandpits |
| **Baked-in** | Edit `Dockerfile`, rebuild container | ✅ Yes | Things you always want available |

> **Tip:** Start on-demand. If you find yourself reinstalling the same thing every time, bake it in.

---

## On-demand installs (no rebuild needed)

### System packages
```bash
sudo apt-get install -y <package>
# e.g.
sudo apt-get install -y postgresql-client redis-tools ffmpeg
```

### Python packages
```bash
pip install <package>           # into the active venv / globally
pip install -r requirements.txt
```

### Node packages
```bash
npm install <package>           # local to project
npm install -g <package>        # global
```

### JVM languages via SDKMAN
SDKMAN is pre-installed. Use it to manage any JVM-ecosystem tool:

```bash
# List what's installed
sdk list

# Java — browse and install a specific version
sdk list java
sdk install java 21.0.3-tem     # Temurin (Eclipse) LTS
sdk install java 17.0.11-tem
sdk use java 17.0.11-tem        # switch for this shell session
sdk default java 21.0.3-tem     # set default permanently

# Scala
sdk install scala               # latest
sdk install scala 2.13.14       # specific version
sdk install scalacli            # Scala CLI (modern scripting/project tool)

# Build tools
sdk install sbt                 # Scala build tool (pre-installed)
sdk install maven
sdk install gradle

# Other JVM languages
sdk install kotlin
sdk install groovy
sdk install java 21.0.1-graalvm # GraalVM (native image)
```

### Go tools
```bash
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/air-verse/air@latest  # live reload
```

### Rust crates (dev tools)
```bash
cargo install cargo-watch       # live reload
cargo install cargo-expand      # macro expansion
```

### Docker Compose (already on host Docker Desktop, but if you need the CLI inside)
```bash
sudo apt-get install -y docker-compose-plugin
```

---

## Baked-in changes (requires container rebuild)

Edit `.devcontainer/Dockerfile` then:

> **Ctrl/Cmd + Shift + P** → `Dev Containers: Rebuild Container`

### Adding a system package permanently
```dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
    your-package-here \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
```

### Pinning a different Java version
In the Dockerfile, change:
```dockerfile
&& sdk install java 21.0.3-tem \
```
to any version from `sdk list java`.

### Removing a language runtime to keep the image lean
Comment out the relevant block in the Dockerfile:
- **Go** — comment out the `ARG GO_VERSION` + `RUN curl ... go.dev` block
- **Rust** — comment out the `rustup` block
- **Java/Scala/SDKMAN** — comment out the SDKMAN block

---

## Starting a new sandpit project

Drop any of these in the repo root and `post-create.sh` picks them up automatically on first build:

| File | Effect |
|---|---|
| `requirements.txt` | Creates `.venv/` and installs Python deps |
| `package.json` | Runs `npm install` |

For Scala/sbt projects, create a standard `build.sbt` in your project folder:
```scala
// build.sbt
ThisBuild / version := "0.1.0"
ThisBuild / scalaVersion := "3.4.2"

lazy val root = (project in file("."))
  .settings(name := "my-sandpit")
```

---

## Useful one-liners

```bash
# Quick HTTP server on port 8080
python3 -m http.server 8080

# Watch and re-run a Python script on change
pip install watchdog
watchmedo shell-command --patterns="*.py" --command="python3 ${watch_src_path}" .

# Run a throwaway Scala script (after: sdk install scalacli)
scala-cli run script.scala

# Run a throwaway Java program
java Main.java        # Java 11+ supports single-file programs

# Format Python
pip install black && black .

# Format Scala
scalafmt --check .    # after adding scalafmt to build.sbt
```
