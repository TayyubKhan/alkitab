# Architecture Decisions: Multi-App Monorepo Strategy

This document outlines the rationale for maintaining separate entry points for the Mobile and Web applications within the `alkitab` project.

## Decision: Separate Mobile and Web App Packages

Instead of running the primary Mobile entry point directly on the web, we have established a dedicated `apps/alkitab_web` package.

### 1. Data Layer Divergence
*   **Mobile**: Uses `drift` (SQLite) with native C bindings for offline-first performance.
*   **Web**: Uses `WebQuranRepository` which communicates directly with `api.quran.com` via HTTP. This avoids the overhead of wasm-based SQLite in the browser unless explicitly needed.

### 2. Dependency Isolation
The Mobile app depends on several plugins that aren't suitable or optimized for the Web:
*   `shake`: For hardware-based feedback (not applicable to desktop web).
*   `path_provider`: For native filesystem access.
*   `screenshot`: For capturing and reporting logs.

By separating the entry points, the Web bundle remains lightweight and free of unnecessary native-bridge code.

### 3. Strategy Pattern via Riverpod
We utilize Riverpod's `overrideWith` capability at the root of each app:
*   In **Mobile**, `quranRepositoryProvider` is overridden with `MobileQuranRepository`.
*   In **Web**, `quranRepositoryProvider` is overridden with `WebQuranRepository`.

### 4. Independent Scaling
This architecture follows the **Industry Standard** for large Flutter projects. It allows:
*   Separate **CI/CD** pipelines (deploying web to Firebase Hosting without waiting for Android/iOS build checks).
*   **A/B Testing**: Different UI layouts or features can be tested on the web before moving to mobile.
*   **Platform-Specific Assets**: Different font-loading strategies to ensure fast First Contentful Paint (FCP) on the web.
