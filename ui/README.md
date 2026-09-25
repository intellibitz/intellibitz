# User Interfaces & Mobile Clients (`ui/`)

This directory encompasses mobile application codebases (primarily Android), web client standards specifications, and documentation authoring tooling.

---

## Directory Overview

```
ui/
├── android/           # Android applications, tools, and test suites
│   ├── IntelliDroid/  # Primary modern Android client project (Gradle)
│   ├── MEvents/       # Mobile events and location tracker
│   ├── TwRends/       # Twitter trends Android client
│   ├── UDigg/         # Social discovery and Digg client
│   ├── wuffittracker/ # GPS tracker and instrumentation suite
│   ├── booksExchange/ # Books exchange mobile client (bex-droid)
│   ├── fiteclub/      # Fiteclub mobile client
│   └── mobeegal/      # Mobile local search client
├── client/            # Web Client Standards & Living Specs
│   ├── README.md      # Standards index and navigation table
│   └── *.md           # HTML, CSS, JS, HTTP/3, WebSockets, Storage, URL specs
└── asciidoc/          # AsciiDoc & Asciidoctor documentation engine guides
```

---

## Projects & Applications

### Primary Project: [IntelliDroid](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/android/IntelliDroid)
Modern Gradle-based Android application.
- **Language**: Java / Kotlin
- **Build System**: Gradle Wrapper (`./gradlew`)
- **Key Modules**: GCM messaging, account management, contact syncing, content providers.

### Web Client Living Standards: [`ui/client/`](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/client)
Curated documentation and references for modern frontend architecture:
- HTML Living Standard
- CSS Cascading Style Sheets
- ECMAScript / JavaScript Language Specifications
- HTTP/3 and QUIC transport protocol
- WebSockets and XMLHttpRequest

### Android Development Utilities
- **`adb-pull-alldata-device.sh`**: Pulls application state and databases from an attached device or emulator.
- **`install-kvm.sh`**: Configures KVM hardware acceleration for the Android Emulator on Linux.
- **`local.properties.example`**: Configuration template for Android SDK path binding.
