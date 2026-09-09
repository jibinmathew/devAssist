# 🚀 DevPilot — iOS Developer AI Assistant

![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg?style=flat&logo=swift)
![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B%20%7C%20macOS%2014%2B-blue.svg?style=flat&logo=apple)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20%2B%20MVVM-purple.svg)
![Persistence](https://img.shields.io/badge/Persistence-SwiftData-green.svg)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-black.svg?logo=github-actions)

**DevPilot** is a production-grade, multiplatform Swift/SwiftUI application architected to assist iOS developers with automated crash diagnostics, software architecture design, unit test generation, and static code reviews. 

Rather than acting as a simple wrapper around a chatbot, **DevPilot** demonstrates how to build a robust, scalable iOS codebase using **Clean Architecture**, **Swift Concurrency** (`async/await`, `@MainActor`, Actors), **SwiftData** local persistence, **Keychain credential security**, and protocol-oriented domain boundaries with high-fidelity offline execution capabilities.

---

## 🏛️ System Architecture

DevPilot strictly adheres to 3-tier **Clean Architecture** and **MVVM**, guaranteeing total separation between presentation UI, business domain rules, and data persistence layers.

```
                          ┌───────────────────────────┐
                          │     Presentation Layer    │
                          │ SwiftUI Views + ViewModels│
                          └─────────────┬─────────────┘
                                        │ (async / @MainActor)
                                        ▼
                          ┌───────────────────────────┐
                          │        Domain Layer       │
                          │  UseCases + Protocols     │
                          └─────────────┬─────────────┘
                                        │
                    ┌───────────────────┴───────────────────┐
                    ▼                                       ▼
     ┌────────────────────────────┐           ┌────────────────────────────┐
     │         Data Layer         │           │        Data Layer          │
     │       SwiftData Models     │           │      Network & AI Service  │
     │     (Local Persistence)    │           │ (Gemini REST API / Mock)   │
     └────────────────────────────┘           └────────────────────────────┘
```

### Layer Responsibilities

- **Domain Layer (`Domain/`)**: Completely framework-agnostic. Contains core domain entities (`AnalysisResult`, `AnalysisType`), Use Cases (`AnalyzeBugUseCase`, `DesignArchitectureUseCase`, etc.), and protocol definitions (`AIServiceProtocol`, `AnalysisRepositoryProtocol`).
- **Data Layer (`Data/`)**: Concrete implementations including `@ModelActor`-backed `AnalysisRepository` for **SwiftData**, `GeminiAIService` for REST networking, `MockAIService` for offline execution, and `KeychainManager` for credential isolation.
- **Presentation Layer (`Presentation/`)**: Built using **SwiftUI** and `@MainActor`-isolated ViewModels. Includes a modular Design System (`GlassCard`, `CodeEditorView`, `StatusBadge`, `PrimaryButton`, `Theme`).

---

## 💻 Key Features & Developer Tools

| Feature Tool | Description | Key Tech / Highlights |
| :--- | :--- | :--- |
| 🐛 **Bug Analyzer** | Paste crash logs, stack traces, or failing code. AI identifies root cause, severity, and generates an executable patch fix. | Concurrency safety checks, `@MainActor` dispatch fixes, inline code diff preview. |
| 🏗️ **Architecture Designer** | Input system requirements and technical constraints. AI drafts a multi-tier Clean Architecture specification, protocol layout, and data flow guidelines. | Protocol-Oriented Design (POP), repository pattern blueprints, SwiftData caching specs. |
| 🧪 **Test Suite Generator** | Input source code. AI generates unit tests using **XCTest** or modern **Swift Testing**, including mock stubs and async error assertions. | Async test handling, mock protocol injections, edge case coverage. |
| 💻 **Code Reviewer** | Paste code or PR diffs. Performs static analysis inspecting retain cycles, thread safety hazards, memory leaks, and performance anti-patterns. | Static code analysis, `NSCache`/Actor recommendations, closure retain cycle audit. |
| 📚 **Persistent History Log** | Query, filter, and inspect past analysis results. Powered by **SwiftData** with full category filtering and search. | `@Model` schema, actor isolation, swipe-to-delete, detailed markdown inspector. |
| ⚙️ **Keychain & Settings** | Optional Gemini AI key configuration with iOS Keychain encryption and seamless offline mock fallback. | `Security.framework`, zero required hardcoded keys, instant offline mode toggle. |

---

## 📁 Repository Directory Breakdown

```
DevAssist/
├── DevAssist/
│   ├── DevAssistApp.swift              # SwiftData ModelContainer & App Entry
│   ├── Domain/
│   │   ├── Models/                     # AnalysisResult, AnalysisType Domain Entities
│   │   ├── Services/                   # AIServiceProtocol
│   │   ├── Repositories/               # AnalysisRepositoryProtocol
│   │   └── UseCases/                   # 4 Core Feature Use Cases
│   ├── Data/
│   │   ├── Models/                     # AnalysisRecord (@Model for SwiftData)
│   │   ├── Repositories/               # Actor-isolated AnalysisRepository
│   │   ├── Services/                   # GeminiAIService & MockAIService
│   │   └── Security/                   # KeychainManager (iOS Keychain)
│   └── Presentation/
│       ├── DesignSystem/               # GlassCard, CodeEditorView, StatusBadge, Theme
│       ├── Home/                       # HomeView & HomeViewModel (Dashboard)
│       ├── BugAnalyzer/                # BugAnalyzerView & ViewModel
│       ├── ArchDesigner/               # ArchDesignerView & ViewModel
│       ├── TestGenerator/              # TestGeneratorView & ViewModel
│       ├── CodeReviewer/               # CodeReviewerView & ViewModel
│       ├── History/                    # HistoryListView, HistoryDetailView & ViewModel
│       └── Settings/                   # SettingsView & SettingsViewModel
├── DevAssistTests/                     # XCTest Unit Suite (ViewModels, Repositories, Mocks)
└── .github/workflows/ci.yml           # GitHub Actions iOS Simulator Build & Test Pipeline
```

---

## 🛠️ Build & Verification Instructions

### Requirements
- **Xcode**: 16.0+
- **Swift**: 6.0+
- **Deployment Target**: iOS 17.0+ / macOS 14.0+

### Building via Xcode
Open `DevAssist.xcodeproj` in Xcode and select target **DevAssist** with destination **iPhone 16 Simulator** or **My Mac**, then press `Cmd + R`.

### Building via Command Line (`xcodebuild`)
```bash
# Build iOS Simulator Target
xcodebuild -project DevAssist.xcodeproj -scheme DevAssist -sdk iphonesimulator build

# Build macOS Target
xcodebuild -project DevAssist.xcodeproj -scheme DevAssist -destination 'platform=macOS' build

# Run XCTest Unit Test Suite
xcodebuild -project DevAssist.xcodeproj -scheme DevAssist -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17' test
```

---

## 🧪 Testing & CI/CD Pipeline

The project includes an **XCTest** suite covering:
1. `MockAIServiceTests`: Validating outputs across all 4 developer tools.
2. `BugAnalyzerViewModelTests`: Testing async state propagation (`@MainActor`) and SwiftData persistence side effects.
3. `AnalysisRepositoryTests`: Testing CRUD operations using an in-memory `ModelContainer`.

Automated testing is enforced via **GitHub Actions** ([.github/workflows/ci.yml](file:///.github/workflows/ci.yml)), which triggers clean builds and test runs on every push or pull request to `main`.
