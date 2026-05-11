# Chapter & Roast (GDG Campus Coffee) ☕✨

A premium Flutter application built for the **GDG Campus Coffee** community. This app combines modern aesthetics with powerful features like the **Grounds Oracle** (AI-powered fortune telling) and a high-fidelity **Caffè & Codex** menu.

---

## 🌟 Features

- **Grounds Oracle**: Mystical AI-powered coffee fortunes using Gemini 1.5 Flash.
- **Dynamic Menu**: A beautiful, responsive menu with smooth animations and high-fidelity visuals.
- **Branch Locator**: Find your nearest coffee branch with integrated maps.
- **Premium UI**: Crafted with a focus on aesthetics, using custom typography and rich gradients.

---

## 🚀 Getting Started

To get this project running locally, follow these steps:

### 1. Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- A Gemini API Key from [Google AI Studio](https://aistudio.google.com/app/apikey)

### 2. Configure Secrets
We use a centralized secrets management system to keep API keys secure.
- Copy `lib/core/constants/secrets.dart.example` to `lib/core/constants/secrets.dart` and add your **Gemini API Key**.
- Copy `android/secrets.properties.example` to `android/secrets.properties` and add your **Google Maps API Key**.

### 3. Setup Firebase
- Place your `google-services.json` in `android/app/`.
- Place your `GoogleService-Info.plist` in `ios/Runner/`.

### 4. Run the App
```bash
flutter pub get
flutter run
```

---

## 🛠 Tech Stack
- **Framework**: Flutter
- **State Management**: Provider
- **AI**: Google Generative AI (Gemini)
- **Database**: Firebase Firestore & Storage
- **Maps**: Google Maps Flutter

---

## 📝 License
This project is for educational purposes as part of the GDG Campus Coffee initiative.
