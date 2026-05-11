# Chapter & Roast ☕📖

A premium Flutter app that blends the world of coffee and literature — curated brews, nearby café discovery, and an AI-powered sommelier to guide every cup.

Built as part of the **GDG Build With AI** (May 2026, Adana).

---

## Screenshots

| | |
|:---:|:---:|
| ![image1](https://github.com/user-attachments/assets/6e034a2b-a8d3-4099-9727-d5ac45eb3a68) | ![image2](https://github.com/user-attachments/assets/530fb2bc-caf4-4b7d-9a5c-ab5ddc326918) |

---

## Features

- **Curated Menu** — Coffee catalog with flavor profiles, intensity tags, and pricing
- **Café Map** — Discover nearby roasteries and branches with integrated Google Maps
- **AI Brew Assistant** — Powered by Gemini; recommends the perfect brew for your mood, book, or moment
- **Premium UI** — Dark luxury aesthetic with custom typography and smooth animations

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | Provider |
| AI | Google Generative AI (Gemini 1.5 Flash) |
| Database | Firebase Firestore & Storage |
| Maps | Google Maps Flutter |

---

## Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- Android Studio or VS Code
- A Gemini API key from [Google AI Studio](https://aistudio.google.com/app/apikey)
- A Google Maps API key

### 1. Clone the repo

```bash
git clone https://github.com/mustafaerendalgic/ChapterAndRoast.git
cd ChapterAndRoast
```

### 2. Configure API keys

Copy the example secrets files and fill in your keys:

```bash
cp lib/core/constants/secrets.dart.example lib/core/constants/secrets.dart
cp android/secrets.properties.example android/secrets.properties
```

### 3. Set up Firebase

- Place `google-services.json` in `android/app/`
- Place `GoogleService-Info.plist` in `ios/Runner/`

### 4. Run

```bash
flutter pub get
flutter run
```

---

## Built At

**GDG Build With AI** — May 9–10, 2025, Adana  
Developed with the support of AI tools including Google Stitch and Antigravity.

---

## License

This project was created for educational purposes as part of the GDG Campus Coffee initiative.
