# Klaussified

A modern Secret Santa web application built with Flutter and Firebase.

## About

Klaussified makes organizing Secret Santa gift exchanges simple and fun. Create groups, invite friends, and let the app handle random assignments while keeping everything secret.

## Features

- **User Authentication** - Secure email/password login
- **Group Management** - Create and manage Secret Santa groups
- **Invitation System** - Send invites that members can accept or decline
- **Random Assignments** - Automated Secret Santa picker with slot machine animation
- **Profile Details** - Share wishlists and gift preferences
- **Member Management** - Remove members before starting the exchange
- **Reveal System** - Controlled reveal when ready

## Tech Stack

- **Frontend:** Flutter (Web)
- **Backend:** Firebase (Authentication, Firestore, Hosting)
- **State Management:** BLoC Pattern
- **Routing:** go_router
- **Code Generation:** freezed + json_serializable

## Project Structure

```
lib/
├── core/                 # Theme, routes, constants
├── data/                 # Models, repositories, services
├── business_logic/       # BLoC state management
└── presentation/         # UI screens and widgets
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0+)
- Firebase project

### Installation

1. Clone and install dependencies
```bash
git clone https://github.com/yourusername/klaussified.git
cd klaussified
flutter pub get
```

2. Configure Firebase
   - Create a Firebase project
   - Enable Email/Password authentication
   - Set up Firestore database
   - Add Firebase config to `lib/firebase_options.dart`

3. Run
```bash
flutter run -d chrome
```

## License

MIT License
