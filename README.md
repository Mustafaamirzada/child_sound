# 🎓 Child Sound

**An interactive Persian (Dari) alphabet and vocabulary learning app for children — built with Flutter.**

Child Sound turns learning to read into a game. Through a full alphabet, 266 illustrated words, three quiz modes, a writing trainer, gamified achievements, and a parent dashboard, kids learn letters and words by hearing, seeing, and playing — while parents can quietly track real progress.

---

## ✨ Why Child Sound?

| Problem | How Child Sound solves it |
| --- | --- |
| Kids get bored with rote memorization | Full game-loop: swipe-and-listen cards, confetti, streaks, badges & achievements |
| Static PDF-style alphabet apps | Real **audio-first** teaching — every word is read aloud (mp3, with a Persian TTS fallback) |
| No visibility for parents | A **parent dashboard** with daily activity, weekly bar chart, streak, accuracy, and per-level word progress |
| One-size-fits-all pace | **5 difficulty levels** from one-syllable to five-syllable words |
| Confusing, cluttered UI | Bright, child-friendly, fully **RTL Persian** interface with big buttons and emoji cues |
| Data privacy worries | **100% offline & private** — all progress is stored only on the device |

---

## 🚀 Features

### 📖 Alphabet (الفبا)
- All **34 Persian letters**, each with a real word and emoji
- Tap a letter to open a swipeable lesson card with audio pronunciation
- "One new letter per day" pacing to build a healthy daily habit
- Completed letters are marked with a ✓ check

### 📚 Word Levels (تمرین کلمات)
- **266 words across 5 progressive levels:** 90 one‑syllable · 80 two‑syllable · 61 three‑syllable · 30 four‑syllable · 5 five‑syllable
- Beautifully illustrated cards with **human‑recorded audio** (129 mp3 voice clips) and TTS fallback
- A card is "mastered" after **3 listen-and-repeat plays**, unlocking confetti 🎉 and achievements

### ✍️ Writing Trainer (تمرین نوشتن)
- Letter-scramble puzzles: arrange shuffled letters into the correct word
- Instant feedback, live progress bar, and a celebration on completion

### 🎯 Interactive Quizzes (امتحان)
Three modes, randomly generated each time:
- **امتحان حروف** — find the letter a picture starts with
- **امتحان تصاویر** — pick the word that matches the image
- **امتحان صوتی** — listen to the audio and choose the right word (with replay)

With instant green/red answer feedback, score tracking, retry, and result screens.

### 🏆 Gamification & Achievements
- **10 achievements**, from *اولین حرف* (first letter) to *استاد کلمات* (word master) and *یک ماه مداوم* (30‑day streak)
- Learning streaks 🔥, daily tracking, and a 100% perfect-quiz star ⭐

### 📊 Parent Dashboard (داشبورد والدین)
- Today's words learned + overall quiz accuracy
- Animated alphabet progress ring
- **Weekly activity bar chart** (fl_chart)
- Per-level word progress bars
- Streak card with day dots
- Quick settings: sound on/off, dark mode, daily reminder

### 👤 Profile & Settings
- Choose from 10 emoji avatars, edit the child's name
- Level labels (مبتدی → استاد) based on letters mastered
- **Dark mode**, sound toggle, and daily reminder switches
- One-tap "reset progress" (with confirmation) to start fresh
- About section and RTL-friendly navigation drawer with privacy/help dialogs

### 🛡️ Privacy
No accounts, no ads, no data leaving the device. Everything is stored locally via `shared_preferences`, stated clearly in the in-app privacy dialog.

---

## 🧱 Tech Stack

- **Flutter** (Dart SDK `^3.10.7`)
- `audioplayers` — mp3 pronunciation
- `flutter_tts` — Persian text-to-speech fallback
- `shared_preferences` — local persistence
- `fl_chart` — parent dashboard charts
- `confetti` — celebration effects
- `lottie` + `pretty_animated_buttons` — playful UI
- `intl` — date handling
- `flutter_localizations` — full RTL Persian locale

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── services/          # stats, settings, storage keys, legacy migration
│   └── theme/             # light/dark themes + theme controller
├── features/
│   ├── alphabets/         # alphabet grid + letter lessons
│   ├── words/             # 5 word levels + word cards
│   ├── writing/           # letter-scramble writing trainer
│   ├── quiz/              # 3 quiz modes + result screens
│   ├── dashboard/         # parent dashboard & analytics
│   ├── profile/           # avatar, name, settings, reset
│   ├── onboarding/        # first-run intro
│   └── splash/            # name input & startup
└── shared/
    ├── components/        # reusable UI pieces
    └── widgets/           # drawer, pager, RTL icon helpers
```

---

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK `3.10.7` or newer (Dart `^3.10.7`)
- An Android/iOS device or emulator

### Run
```bash
flutter pub get
flutter run
```

### Build
```bash
flutter build apk --debug     # debug APK
flutter build apk --release   # release APK
```

### Test
The project ships with a real test suite (20 tests) covering quiz data generation and core widget flows:

```bash
flutter test
```

Verify code health:

```bash
flutter analyze
```

---

## ✅ Content Coverage

- **34** Persian letters with example words
- **266** words across **5** difficulty levels
- **129** human-recorded pronunciation clips (+ TTS fallback)
- **3** randomized quiz modes
- **10** unlockable achievements

---

## 🗺️ Roadmap

- [ ] Daily practice reminders with local notifications
- [ ] Sound packs for two/four/five-syllable words (currently TTS fallback)
- [ ] Multiple child profiles
- [ ] Exportable progress reports for parents
- [ ] More writing mini-games

---

## 📄 License

This project is private and not published to pub.dev (`publish_to: 'none'`).

---

<p align="center">Made with ❤️ for the next generation of readers.</p>
