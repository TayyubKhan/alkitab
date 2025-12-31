# Qudwa - AI-Powered Quranic Assistant & Reader

Qudwa is a premier Quranic application that blends traditional religious scholarship with modern Artificial Intelligence. Designed to be more than just a digital reader, Qudwa serves as an interactive companion, providing users with AI-driven insights, multi-translation research tools, and a premium audio experience for spiritual growth.

## 🚀 Introduction

Qudwa (meaning "Example" or "Role Model") is built to bring the wisdom of the Quran closer to users through an advanced AI ChatBot. By integrating Google's Gemini AI, the app allows users to "research" and ask questions about the Quranic text, receiving grounded and scholarly-focused responses. Alongside its AI capabilities, Qudwa offers a high-fidelity reading interface with support for multiple classical Arabic scripts and high-quality audio recitations.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Multi-platform support)
- **State Management**: [Riverpod](https://riverpod.dev/) (Type-safe, reactive state handling)
- **Artificial Intelligence**: 
  - **Google Generative AI**: Gemini AI integration for the Quranic ChatBot.
  - **Firebase AI**: Backend-optimized AI services.
- **Backend & Cloud**: [Firebase](https://firebase.google.com/) (Auth, Firestore, and AI suite)
- **Data Persistence**:
  - **Drift**: A high-performance, reactive persistence library for SQLite.
  - **Secure Storage**: Encrypted storage for API keys and sensitive user configurations.
- **Audio Experience**: 
  - **Just Audio**: Professional-grade audio player with background playback support.
  - **Audio Session**: Advanced management of audio focus and sessions.
- **Typography**: Specialized rendering engine for multiple font families (Amiri, PDMS Saleem, Gulzar, etc.) ensuring beautiful Arabic and Urdu calligraphy.

## ✨ Key Features

- **AI Quranic ChatBot**: Interact with a specialized AI assistant (Grounding with Gemini) to research Quranic verses, themes, and interpretations.
- **Immersive Quran Reader**: A high-fidelity reading experience with support for several classical and modern Arabic fonts.
- **Advanced Audio Player**: Stream or download high-quality recitations with support for background playback and Lockscreen controls.
- **Multi-Translation Research**: Access and compare various translations in English, Urdu, and more, all optimized for readability.
- **Offline Reliability**: Full local persistence using the Drift database, allowing for a seamless experience even without an active internet connection.
- **Rich Markdown Support**: AI insights are rendered in beautiful formatted markdown for clarity and emphasis.
- **Secure Synchronization**: Synchronize preferences and search history securely across devices using Firebase and encrypted local storage.

## 📂 Architecture

Qudwa utilizes a **Reactive Layered Architecture**:
- `features`: Domain modules including Quran Reader, Onboarding, and Settings.
- `viewmodels`: Business logic layer powered by Riverpod and custom logic hubs.
- `data`: Repositories and local database (Drift) implementations.
- `core`: Infrastructure for AI orchestration, audio management, and shared utilities.

---
*Elevating your Quranic journey through AI and technology.*
