# Source Control Management & DevOps (`scm/`)

This directory contains infrastructure automation, continuous integration toolchains, containerization setups, virtualization recipes, and developer environment management.

---

## Tooling Matrix

| Domain | Path | Key Capabilities |
| :--- | :--- | :--- |
| **Git & Platforms** | [`git/`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/git) | AsciiDoc Pro Git guide ([`git-scm.org.adoc`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/git/git-scm.org.adoc)), GitHub CLI automation (`github/`), GitLab (`gitlab/`), Bitbucket (`bitbucket/`). |
| **Docker** | [`docker/`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/docker) | Docker Engine installation, rootless Docker ([`dockerinstall-rootless.sh`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/docker/dockerinstall-rootless.sh)), Docker Desktop ([`install-dockerdesktop.md`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/docker/install-dockerdesktop.md)), multi-service Compose files, Dockerfile templates. |
| **Kubernetes** | [`kubernetes/`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/kubernetes) | `kubectl` CLI installation ([`bin/kubectlinstall.sh`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/kubernetes/bin/kubectlinstall.sh)), cluster operations reference ([`myKubectl.md`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/kubernetes/myKubectl.md)). |
| **Multipass VMs** | [`multipass/`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/multipass) | Canonical Multipass VM orchestration, Docker blueprint instances, PostgreSQL and XRDP desktop VMs. |
| **Gradle** | [`gradle/`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/gradle) | Comprehensive AsciiDoc Gradle guides ([`gradle.org.adoc`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/gradle/gradle.org.adoc)), sample multi-project builds ([`GradleAuthoring/`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/gradle/GradleAuthoring), [`GradleRunning/`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/gradle/GradleRunning)), Kotlin DSL reports. |
| **Package Managers** | [`brew/`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/brew)<br>[`flatpak/`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/flatpak)<br>[`sdkman/`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/sdkman) | Homebrew automated installer ([`install-brew.sh`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/brew/install-brew.sh)), Flatpak flathub configs, SDKMAN multi-JDK manager. |
| **IDEs** | [`ide/`](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/ide) | JetBrains Toolbox and NetBeans environment setup. |

---

## DevOps Quickstarts

### Install Docker Engine on Ubuntu
```bash
./scm/docker/dockerinstall.sh
```

### Setup Rootless Docker
```bash
./scm/docker/dockerinstall-rootless.sh
```

### Launch an Ubuntu VM via Multipass
```bash
./scm/multipass/launchMpDocker.sh
```
