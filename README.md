# IntelliBitz

<p align="center">
  <strong>Comprehensive DevOps, Systems Infrastructure, Cloud Platforms & Multi-Platform Software Suite</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT" />
  <img src="https://img.shields.io/badge/OS-Linux%20%7C%20Windows%20WSL-orange.svg" alt="OS Support" />
  <img src="https://img.shields.io/badge/Docker-Engine%20%26%20Compose-2496ED.svg" alt="Docker" />
  <img src="https://img.shields.io/badge/Kotlin-Multiplatform-7F52FF.svg" alt="Kotlin" />
  <img src="https://img.shields.io/badge/Android-Gradle%20Suite-3DDC84.svg" alt="Android" />
  <img src="https://img.shields.io/badge/Database-PostgreSQL%20%7C%20MySQL%20%7C%20SQLite-336791.svg" alt="Databases" />
</p>

---

## Overview

**IntelliBitz** is an engineering monorepo and knowledge base providing containerized services, system administration tooling, cloud automation, mobile client architectures, and language toolchains.

The repository is organized into **five foundational pillars**:

```
intellibitz/
├── db/        # Databases: PostgreSQL, MySQL, SQLite, rqlite, CouchDB, TOML, JSON
├── os/        # Operating Systems: Linux (Ubuntu, Arch), Windows/WSL, Language toolchains
├── scm/       # DevOps & SCM: Git, Docker, Kubernetes, Multipass, Gradle, SDKMAN
├── ui/        # User Interfaces: Android clients (IntelliDroid), Web Standards, AsciiDoc
└── web/       # Web & Cloud: Web servers, GCP automation, Enterprise Java EE backends
```

---

## Directory Index & Architecture

### 🗄️ [Databases (`db/`)](file:///home/ramadoss/github.com/intellibitz/intellibitz/db/README.md)
Container stacks, database administration scripts, schemas, and data specifications.
- **[PostgreSQL](file:///home/ramadoss/github.com/intellibitz/intellibitz/db/postgresql)**: [`docker-compose.yml`](file:///home/ramadoss/github.com/intellibitz/intellibitz/db/postgresql/docker-compose.yml) (Postgres + pgAdmin 4), [`myPgsql.sql`](file:///home/ramadoss/github.com/intellibitz/intellibitz/db/postgresql/myPgsql.sql) schema definitions, [`myPgsql.sh`](file:///home/ramadoss/github.com/intellibitz/intellibitz/db/postgresql/myPgsql.sh) management script, Docker Swarm [`stack.yml`](file:///home/ramadoss/github.com/intellibitz/intellibitz/db/postgresql/stack.yml).
- **[MySQL](file:///home/ramadoss/github.com/intellibitz/intellibitz/db/mysql)**: [`docker-compose.yml`](file:///home/ramadoss/github.com/intellibitz/intellibitz/db/mysql/docker-compose.yml) stack, [`myMySQL.sql`](file:///home/ramadoss/github.com/intellibitz/intellibitz/db/mysql/myMySQL.sql) schema, [`myMySQLCmd.sh`](file:///home/ramadoss/github.com/intellibitz/intellibitz/db/mysql/myMySQLCmd.sh) cheatsheet.
- **[SQLite](file:///home/ramadoss/github.com/intellibitz/intellibitz/db/sqlite)**: Embedded database usage & CLI commands.
- **[rqlite](file:///home/ramadoss/github.com/intellibitz/intellibitz/db/rqlite)**: Distributed SQLite with Raft consensus.
- **[CouchDB](file:///home/ramadoss/github.com/intellibitz/intellibitz/db/couchdb)**: Document-oriented database operations and Fauxton setup.
- **[Specifications](file:///home/ramadoss/github.com/intellibitz/intellibitz/db/toml)**: [TOML v1.0.0 Specification](file:///home/ramadoss/github.com/intellibitz/intellibitz/db/toml/toml-v1.0.0.md) and [JSON Standards](file:///home/ramadoss/github.com/intellibitz/intellibitz/db/json/myJson.md).

### 🖥️ [Operating Systems & Runtimes (`os/`)](file:///home/ramadoss/github.com/intellibitz/intellibitz/os/README.md)
Operating system administration and programming language environments.
- **[Linux Administration](file:///home/ramadoss/github.com/intellibitz/intellibitz/os/linux)**: Ubuntu system updates (`apt-full-upgrade.sh`), Samba sharing (`mySamba.sh`), OpenSSH hardening (`ssh/`), GnuPG key management (`gpg/`), Arch Linux architecture guide (`arch/archlinux.org.adoc`), and GRUB dual-boot recovery ([`grub.md`](file:///home/ramadoss/github.com/intellibitz/intellibitz/os/linux/grub.md)).
- **[Windows & WSL](file:///home/ramadoss/github.com/intellibitz/intellibitz/os/win)**: WSL configuration and Windows service scripts.
- **[Language Toolchains](file:///home/ramadoss/github.com/intellibitz/intellibitz/os/lang)**:
  - **[Kotlin](file:///home/ramadoss/github.com/intellibitz/intellibitz/os/lang/kotlin)**: Tutorial suite (`KotlinLearn`), sandbox (`KotlinPlay`), multiplatform modules (`multiplatform`), web clients (`jsfront`, `mpfsweb`).
  - **[Java SE](file:///home/ramadoss/github.com/intellibitz/intellibitz/os/lang/javase)**: Tamil font transliterator desktop application (`FontTransliterator`), text editors (`sted`).
  - **[Python & AI](file:///home/ramadoss/github.com/intellibitz/intellibitz/os/lang/python)**: Conda/pip setups, Hugging Face Hub CLI guide ([`huggingface.md`](file:///home/ramadoss/github.com/intellibitz/intellibitz/os/lang/python/huggingface.md)), Google Colab & Gemini API ([`colab.md`](file:///home/ramadoss/github.com/intellibitz/intellibitz/os/lang/python/colab.md)), Meta Llama 3 ([`meta-llama.md`](file:///home/ramadoss/github.com/intellibitz/intellibitz/os/lang/python/meta-llama.md)).
  - **[Go](file:///home/ramadoss/github.com/intellibitz/intellibitz/os/lang/go)**: Workspaces, modules, testing, and binaries.
  - **[Clojure](file:///home/ramadoss/github.com/intellibitz/intellibitz/os/lang/clojure)**: Language Reader syntax and data structure reference ([`myClojure.md`](file:///home/ramadoss/github.com/intellibitz/intellibitz/os/lang/clojure/myClojure.md)).
  - **[Expect](file:///home/ramadoss/github.com/intellibitz/intellibitz/os/lang/expect)**: OpenVPN and SFTP interactive automation scripts ([`expect-openvpn.exp`](file:///home/ramadoss/github.com/intellibitz/intellibitz/os/lang/expect/expect-openvpn.exp), [`expect-sftp.exp`](file:///home/ramadoss/github.com/intellibitz/intellibitz/os/lang/expect/expect-sftp.exp)).

### 🔄 [DevOps & Source Control (`scm/`)](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/README.md)
CI/CD workflows, containerization, and developer tooling.
- **[Docker](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/docker)**: Engine install scripts, rootless daemon configuration ([`dockerinstall-rootless.sh`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/docker/dockerinstall-rootless.sh)), Docker Desktop setup guide ([`install-dockerdesktop.md`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/docker/install-dockerdesktop.md)), Compose templates (HTTPD, Postgres, Ubuntu).
- **[Git & Platforms](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/git)**: Pro Git complete AsciiDoc guide ([`git-scm.org.adoc`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/git/git-scm.org.adoc)), GitHub CLI automation, GitLab, Bitbucket.
- **[Kubernetes](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/kubernetes)**: `kubectl` installation script and operations reference.
- **[Multipass](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/multipass)**: Lightweight Ubuntu VM cluster automation, XRDP desktop instances, and Docker blueprint containers.
- **[Gradle](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/gradle)**: AsciiDoc Gradle user guides ([`gradle.org.adoc`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/gradle/gradle.org.adoc)), sample multi-project builds (`GradleAuthoring`, `GradleRunning`).
- **[Package Managers](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/brew)**: Homebrew automated installer ([`install-brew.sh`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/brew/install-brew.sh)), Flatpak, and SDKMAN.

### 📱 [User Interfaces & Clients (`ui/`)](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/README.md)
Mobile client applications and web frontend living standards.
- **[Android Applications](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/android)**:
  - **[IntelliDroid](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/android/IntelliDroid)**: Primary Android client built with modern Gradle, Java, and Kotlin.
  - **Legacy Application Suites**: Location trackers (`wuffittracker`), event managers (`MEvents`), social readers (`TwRends`, `UDigg`), mobile exchange (`booksExchange`), fight club (`fiteclub`).
  - **Device Tools**: ADB data pull/push utilities, KVM acceleration setup (`install-kvm.sh`), and [`local.properties.example`](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/android/local.properties.example).
- **[Web Client Standards](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/client/README.md)**: Curated WHATWG & W3C specifications for HTML, CSS, JavaScript, HTTP/3, WebSockets, Storage, and URL.
- **[AsciiDoc Documentation](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/asciidoc)**: Asciidoctor authoring documentation.

### 🌐 [Web & Cloud Infrastructure (`web/`)](file:///home/ramadoss/github.com/intellibitz/intellibitz/web/README.md)
Web servers, cloud provisioning, and enterprise backend architectures.
- **[Web Servers](file:///home/ramadoss/github.com/intellibitz/intellibitz/web)**: Configuration recipes for Apache HTTP Server, Nginx, Caddy TLS reverse proxy, Node.js, and Apache Tomcat.
- **[Google Cloud Platform](file:///home/ramadoss/github.com/intellibitz/intellibitz/web/google)**: CLI scripts for Compute Engine VM and disk creation, IAM service accounts, OAuth scope inspection, and Cloud SDK automation.
- **[Java EE Enterprise Backends](file:///home/ramadoss/github.com/intellibitz/intellibitz/web/javaee)**: Multi-module Maven enterprise architectures:
  - **IntelliDocs**: Enterprise document platform (`intellidocs-ear`, `intellidocs-ejb`, `intellidocs-war`).
  - **IntelliMeet**: Collaborative meeting platform (`32tango` backend paired with companion `dating` Android mobile client).

---

## Quickstart Guide

### 1. Launch Local Databases
```bash
# Start PostgreSQL 16 + pgAdmin 4:
cd db/postgresql
docker compose up -d

# Start MySQL 8.0:
cd ../mysql
docker compose up -d
```

### 2. Build the Android Client
```bash
cd ui/android/IntelliDroid
./gradlew assembleDebug
```

### 3. Explore Kotlin Multiplatform
```bash
cd os/lang/kotlin/multiplatform
./gradlew build
```

### 4. Run System & DevOps Automation Scripts
All `.sh` scripts in the repository have executable permissions set and have passed syntax validation:
```bash
# Check syntax of any script
bash -n os/linux/ubuntu/apt-full-upgrade.sh

# Run script
./os/linux/ubuntu/apt-full-upgrade.sh
```

---

## Technology Roadmap

See [`roadmap.md`](file:///home/ramadoss/github.com/intellibitz/intellibitz/roadmap.md) for the active architecture status, component milestones, and future development plans.

---

## Contributing & Community

Contributions are warmly welcomed! Please review:
- [Contributing Guidelines](file:///home/ramadoss/github.com/intellibitz/intellibitz/CONTRIBUTING.md)
- [Contributor Code of Conduct](file:///home/ramadoss/github.com/intellibitz/intellibitz/CODE_OF_CONDUCT.md)
- [Security Policy](file:///home/ramadoss/github.com/intellibitz/intellibitz/SECURITY.md)

---

## License

This repository is licensed under the [MIT License](file:///home/ramadoss/github.com/intellibitz/intellibitz/LICENSE).
