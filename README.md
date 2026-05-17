# 📘 Simple Note App – Flutter

A simple and modern note-taking app built with Flutter.

This project is built for learning Flutter, Provider state management, SQLite local database, and clean UI design.

---

## 📱 Screenshots
<img width="850" height="872" alt="image" src="https://github.com/user-attachments/assets/835ceb90-805f-46ce-a492-158d98bd5c77" />

<img width="812" height="847" alt="image" src="https://github.com/user-attachments/assets/fa13c814-6670-414b-a337-db639af25597" />

<img width="796" height="837" alt="image" src="https://github.com/user-attachments/assets/b6643239-4c26-4d00-8ee4-880992791f3a" />


<img width="802" height="877" alt="image" src="https://github.com/user-attachments/assets/f975cd4b-bb31-4e54-8887-4748ac9c0cff" />

## ✨ Features

- Create, edit, delete notes
- Save notes locally using SQLite
- Search notes by keyword
- Filter notes by tag and date range
- Pin important notes
- Lock notes with password
- Custom tags support
- Light / Dark theme toggle
- Toast notifications:
  - Create success
  - Update success
  - Delete success
  - Wrong password
- Clean and simple UI

---

## 🛠 Technologies

| Technology | Purpose |
|------------|--------|
| Flutter | UI framework |
| Provider | State management |
| SQLite (sqflite) | Local database |
| intl | Date formatting |
| Material Design | UI system |

---

## 📂 Project Structure


lib/
│── main.dart
│
├── models/
│ └── note.dart
│
├── database/
│ └── db_helper.dart
│
├── providers/
│ ├── note_provider.dart
│ └── theme_provider.dart
│
├── screens/
│ ├── home_page.dart
│ └── note_editor_screen.dart
│
└── widgets/
└── note_card.dart


---

## 🚀 How to Run

```bash
flutter pub get
flutter run
👨‍💻 Author

Student Project – Flutter Lab Assignment
For learning purposes only.
"# APPNOTE"  
