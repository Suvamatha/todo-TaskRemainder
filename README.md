# FocusFlow 🎯

> A full-stack productivity app for managing tasks, tracking daily progress, and staying focused — built with Flutter & Node.js.

---

## 📱 Screenshots
https://github.com/user-attachments/assets/11dcec99-cb7a-45a6-a0b6-5bb141640409

![alt text](<WhatsApp Image 2026-05-10 at 7.05.15 PM.jpeg>) ![alt text](<WhatsApp Image 2026-05-10 at 7.05.16 PM.jpeg>)

---

## ✨ Features

- 🔐 **Authentication** — Secure register/login with JWT tokens
- ✅ **Task Management** — Add, complete, and delete tasks
- 🚨 **Priority Levels** — Mark tasks as Low, Medium, or High priority
- 📅 **Due Dates** — Set due dates with calendar picker
- ⚠️ **Overdue Detection** — Automatic overdue alerts in red
- 🔔 **Local Notifications** — Get reminded on task due dates at 9:00 AM
- 🔒 **Secure Passwords** — Bcrypt hashing, never stored in plain text
- 💾 **Persistent Storage** — All data saved to MongoDB Atlas
- 🚪 **Auto Login** — Token saved locally, skip login on return

---

## 🛠 Tech Stack

### Frontend (Flutter)
| Package | Purpose |
|---|---|
| `http` | API calls to backend |
| `shared_preferences` | Local token storage |
| `flutter_local_notifications` | Due date reminders |
| `timezone` | Scheduled notifications |

### Backend (Node.js)
| Package | Purpose |
|---|---|
| `express` | REST API framework |
| `mongoose` | MongoDB ODM |
| `bcryptjs` | Password hashing |
| `dotenv` | Environment variables |

### Database
- **MongoDB Atlas** — Cloud database

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed
- Node.js installed
- MongoDB Atlas account

---

### Backend Setup

```bash
# 1. Clone the repo
git clone ""

# 2. Go into the folder
cd task-manager-api

# 3. Install dependencies
npm install

# 4. Create .env file
touch .env
```

Add this to your `.env`:
```
MONGO_URI=your_mongodb_atlas_connection_string
JWT_SECRET=your_secret_key
PORT=3000
```

```bash
# 5. Start the server
node index.js
```

Server runs at `http://localhost:3000` ✅

---

### Flutter Setup

```bash
# 1. Clone the repo
clone the repo

# 2. Go into the folder
cd 

# 3. Install dependencies
flutter pub get

# 4. Run the app
flutter run
```

> ⚠️ If running on Android emulator, change `baseUrl` in `api_service.dart`:
> ```dart
> static const String baseUrl = 'http://10.0.2.2:3000';
> ```

---

## 📡 API Reference

### Auth Routes

| Method | Endpoint | Description | Auth Required |
|---|---|---|---|
| POST | `/auth/register` | Create new account | ❌ |
| POST | `/auth/login` | Login and get token | ❌ |

**Register body:**
```json
{
  "email": "abc@gmail.com",
  "password": "123456"
}
```

**Login response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

### Task Routes

| Method | Endpoint | Description | Auth Required |
|---|---|---|---|
| GET | `/tasks` | Get all tasks | ✅ |
| POST | `/tasks` | Create a task | ✅ |
| PATCH | `/tasks/:id` | Toggle done | ✅ |
| DELETE | `/tasks/:id` | Delete a task | ✅ |

**Create task body:**
```json
{
  "title": "Buy groceries",
  "priority": "high",
  "dueDate": "2025-12-25"
}
```

**Task response:**
```json
{
  "_id": "64abc123...",
  "title": "Buy groceries",
  "done": false,
  "priority": "high",
  "dueDate": "2025-12-25T00:00:00.000Z"
}
```

---

## 📁 Project Structure


### Backend
```
focusflow-api/
├── index.js        # Express app + task routes
├── auth.js         # Register + login routes
├── user.js         # User mongoose schema

├── .env            # Environment variables (never commit!)
└── .gitignore      # Ignores node_modules and .env
```

---

## 🔐 Security

- Passwords hashed with **bcrypt** (10 salt rounds)
- Auth protected with **JWT tokens** (7 day expiry)
- Environment variables in **`.env`** — never committed to GitHub
- **CORS** configured for cross-origin protection

---

## 🗺 Roadmap

- [ ] Categories (Work, Personal, Shopping)
- [ ] Pomodoro focus timer
- [ ] Daily progress tracking
- [ ] Calendar view
- [ ] Dark mode


---

## 👨‍💻 Author

**Your Name**
- GitHub: [@Suvamatha](https://github.com/Suvamatha)

---
