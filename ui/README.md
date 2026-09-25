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

### Mobile Applications Suite: [`ui/android/`](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/android/README.md)
Central hub for all Android mobile applications, modernized to **Android SDK 35**, **Kotlin 2.0.21**, **Gradle 8.13**, and **AGP 8.7.2**:
- **[IntelliDroid](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/android/IntelliDroid/README.md)**: Flagship enterprise messaging and collaboration client (multi-flavor, Coroutines, Room, Firebase FCM, Socket.IO).
- **[MEvents](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/android/MEvents/README.md)**: Mobile event feed and alert tracker (100% Kotlin).
- **[TwRends](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/android/TwRends/README.md)**: Real-time Twitter trending topics visualization (100% Kotlin).
- **[UDigg](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/android/UDigg/README.md)**: Social bookmarking and Digg content discovery reader (100% Kotlin).
- **[wuffittracker](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/android/wuffittracker/README.md)**: GPS location navigation, SMS telemetry, and instrumentation test suite (100% Kotlin).
- **[booksExchange](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/android/booksExchange/README.md)**: Barcode/ISBN scanning book exchange (`bex-droid` client + `bex-engine` GAE cloud).
- **[fiteclub](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/android/fiteclub/README.md)**: Martial arts sparring network (Android client + GAE Python/Django backend).
- **[mobeegal](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/android/mobeegal/README.md)**: Proximity discovery and XMPP instant chat client with web portal.

### Web Client Living Standards: [`ui/client/`](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/client/README.md)
Curated documentation and references for modern frontend architecture:
- HTML Living Standard
- CSS Cascading Style Sheets
- ECMAScript / JavaScript Language Specifications
- HTTP/3 and QUIC transport protocol
- WebSockets and XMLHttpRequest

### Android Development Utilities
- **[`adb-pull-alldata-device.sh`](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/android/adb-pull-alldata-device.sh)**: Pulls application state and databases from an attached device or emulator.
- **[`adb-push-alldata-device.sh`](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/android/adb-push-alldata-device.sh)**: Restores state databases and assets into active emulator instances.
- **[`install-kvm.sh`](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/android/install-kvm.sh)**: Configures KVM hardware acceleration for the Android Emulator on Linux.
- **[`local.properties.example`](file:///home/ramadoss/github.com/intellibitz/intellibitz/ui/android/local.properties.example)**: Configuration template for Android SDK path binding.

---

## Licensing

Distributed under the repository's root **[MIT License](file:///home/ramadoss/github.com/intellibitz/intellibitz/LICENSE)**.
