# Klaussified

A modern, feature-rich Secret Santa web application built with Flutter and Firebase.

## About

Klaussified makes organizing Secret Santa gift exchanges effortless and exciting. Create groups, invite friends, and let the app handle the magic of random assignments while keeping everything secret until the big reveal.

## Key Features

### User Experience

- **Dual Authentication** - Login with email or username for flexibility
- **Christmas-Themed UI** - Festive color scheme (red, green, white) throughout the app
- **Smooth Animations** - Engaging vertical slot machine animation for the Secret Santa draw
- **Responsive Design** - Works seamlessly on desktop and mobile browsers
- **Path-Based URLs** - Clean URLs without hash fragments for better UX
- **Support & Feedback** - In-app contact form and Ko-fi donation support

### Group Management

- **Easy Group Creation** - Set up groups with custom names, descriptions, locations, budgets, and deadlines
- **Flexible Member Limits** - Support for 3 to 100 members per group
- **Member Management** - Add/remove members before starting the exchange
- **Group Ownership** - Owners have special permissions to edit details, manage members, and delete groups
- **Active/Closed States** - Clear distinction between ongoing exchanges and completed ones
- **Group Details** - Optional fields for location, budget suggestions, and pick deadlines

### Invitation System

- **Direct Invitations** - Send invites by username to specific users
- **Accept/Decline** - Members can choose whether to join
- **Notification Indicators** - Visual badges showing pending invitations count
- **Auto-Cleanup** - Declined invitations are automatically removed
- **Duplicate Prevention** - Cannot send duplicate invites to the same user

### Secret Santa Assignment

- **Two-Phase Draw System**:
  - **Owner-Initiated Draw** - Group owner generates all assignments at once using a derangement algorithm
  - **Member Reveal** - Members click to reveal their pre-assigned Secret Santa
- **Smart Derangement Algorithm** - Ensures everyone gets exactly one pick and is picked exactly once, with no self-assignments
- **Fair Random Distribution** - Fisher-Yates shuffle guarantees unbiased assignments
- **Atomic Operations** - All assignments created in a single transaction for data consistency
- **Fallback Assignment** - Legacy one-by-one assignment system as backup

### Profile & Gift Hints

- **Group-Specific Profiles** - Each group has isolated profile details
- **Real Name Field** - Optional real name (separate from username)
- **Hobbies & Interests** - Share what you enjoy to help your Secret Santa
- **Gift Wishes** - Provide hints, sizes, preferences, and wish lists
- **Private Details** - Profile information only visible to your assigned Secret Santa
- **Profile Updates** - Members can update their profile anytime before reveal

### Reveal System

- **Controlled Reveal** - Members can view their assignment anytime after the owner starts the draw
- **Gift Hints Display** - See your pick's profile details, hobbies, and wishes
- **Beautiful Presentation** - Celebration-themed UI with gradient cards and slot machine animation
- **Privacy Reminders** - Visual cues to keep assignments secret
- **Progress Tracking** - See how many members have revealed their assignments

## Technical Highlights

### Frontend Architecture

- **Flutter Web** - Cross-platform framework for beautiful, performant web apps
- **BLoC Pattern** - Predictable state management with flutter_bloc
- **Dependency Injection** - Clean architecture with get_it and injectable
- **Type Safety** - Leverages Dart's strong typing for robust code
- **Code Generation** - Uses freezed and json_serializable for boilerplate reduction

### Backend & Infrastructure

- **Firebase Authentication** - Secure user authentication with email/password
- **Cloud Firestore** - Real-time NoSQL database with offline support and real-time listeners
- **Firebase Cloud Functions** - Serverless TypeScript functions for Secret Santa assignment logic
- **Firebase Hosting** - Fast, secure hosting with global CDN
- **Security Rules** - Granular Firestore rules protecting user data and enforcing business logic

### Advanced Features

- **Real-time Updates** - Stream-based UI updates when group data changes
- **Optimistic UI** - Immediate feedback while waiting for server responses
- **Error Handling** - Comprehensive error messages for user guidance
- **Input Validation** - Client-side and server-side validation

### Developer Experience

- **Auto-Versioning** - PowerShell script to auto-increment build numbers and update version constants
- **Build Automation** - Single-command builds with automatic version increments
- **Type-Safe Routing** - go_router for declarative navigation with type-safe routes
- **URL Strategy** - Path-based URLs (no hash) for cleaner, shareable links
- **Hot Reload** - Flutter's hot reload for rapid development
- **Linting** - Strict Dart analysis options for code quality

## Architecture

### Project Structure

```
lib/
├── core/
│   ├── constants/        # App version, configuration
│   ├── routes/           # go_router configuration
│   ├── theme/            # Colors, text styles
│   └── utils/            # Helper functions
├── data/
│   ├── models/           # Data models (User, Group, Member, Invite)
│   ├── repositories/     # Data access layer (Group, Invite, User)
│   └── services/         # Firebase service wrappers
├── business_logic/
│   ├── auth/             # Authentication BLoC
│   ├── group/            # Group management BLoC
│   └── invite/           # Invitation BLoC
└── presentation/
    ├── screens/          # Full-page screens (Home, Group Details, Profile, etc.)
    └── widgets/          # Reusable UI components

functions/
└── src/
    └── index.ts          # Cloud Functions (generateAllAssignments, revealAssignment)
```

### State Management Flow

```
UI (Presentation)
  ↓ Events
BLoC (Business Logic)
  ↓ Calls
Repository (Data)
  ↓ Queries
Firebase Services
  ↓ Network
Cloud Firestore / Cloud Functions
```

## Algorithm Details

### Secret Santa Assignment Algorithm

The app uses a **derangement algorithm** to ensure fair, random Secret Santa assignments:

1. **Derangement Generation** - Creates a permutation where no element appears in its original position (no self-assignments)
2. **Fisher-Yates Shuffle** - Randomly shuffles the array of user IDs
3. **Validation** - Checks that no user is assigned to themselves
4. **Retry Logic** - Attempts up to 1000 times to find a valid derangement
5. **Atomic Assignment** - All assignments are saved in a single batch transaction

**Key Benefits:**

- Mathematically guaranteed fairness
- No self-assignments possible
- Every person is both a giver and receiver exactly once
- Efficient O(n) time complexity per attempt
- Highly unlikely to fail (derangements exist for all n≥3)
- Completely random and unbiased distribution

### Owner-Initiated Draw Flow

1. Owner clicks "Start the Draw" button
2. Cloud Function `generateAllAssignments` is called
3. Function validates group status and member count (minimum 3)
4. Derangement algorithm generates all assignments
5. All assignments saved atomically to Firestore
6. Group status changes from "pending" to "started"
7. Members can now reveal their assignments

### Member Reveal Flow

1. Member clicks "Reveal My Secret Santa"
2. Cloud Function `revealAssignment` is called
3. Function retrieves pre-generated assignment
4. Assignment is marked as revealed with timestamp
5. Member sees their pick with profile details
6. Slot machine animation plays for celebration

## Design Philosophy

- **Festive Theme** - Christmas colors throughout (red: `#C41E3A`, green: `#165B33`, white: `#FFFAFA`)
- **Clarity** - Clear visual hierarchy and intuitive navigation
- **Feedback** - SnackBar messages for all user actions
- **Accessibility** - High contrast colors and readable text
- **Consistency** - Unified design language across all screens
- **Mobile-First** - Responsive layouts that work on all screen sizes

## Tech Stack Details

### Frontend

- **Flutter 3.5+** - UI framework
- **flutter_bloc 8.1+** - State management
- **go_router 14.6+** - Declarative routing
- **cached_network_image** - Optimized image loading and caching
- **url_launcher** - External link handling for Ko-fi
- **freezed** - Code generation for immutable data classes
- **injectable** - Dependency injection

### Backend

- **Firebase Auth 5.3+** - User authentication
- **Cloud Firestore 5.5+** - Real-time database
- **Cloud Functions (Node 18)** - Serverless TypeScript logic
- **Firebase Hosting** - Static hosting with global CDN

### Development Tools

- **PowerShell Scripts** - Build automation and versioning (`increment_version.ps1`)
- **TypeScript** - Type-safe Cloud Functions
- **Dart Analyzer** - Static code analysis with strict rules
- **VS Code** - Primary IDE with Flutter and Dart extensions

## Security

- **Firestore Security Rules** - Granular permissions for users, groups, and invites
- **Server-Side Validation** - Cloud Functions validate all critical operations
- **Authentication Required** - All operations require authenticated users
- **Owner Permissions** - Only group owners can start draws and delete groups
- **Privacy Protection** - Profile details only visible to assigned Secret Santa

## Creator

Created and maintained by [nairdah](https://github.com/nairdahh)

A solo project developed with care, featuring custom algorithms, animations, and user experience design.

Support the project: [Buy me a coffee ☕](https://ko-fi.com/nairdah)

## License

This is a personal project. All rights reserved.
