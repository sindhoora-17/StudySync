# StudySync — iOS Study Tracker

A native iOS app for planning and tracking study time. Log study sessions against
your courses, see where your time goes, and run focused work blocks with a built-in
Pomodoro timer that can alert you when a session ends.

Built with **UIKit** and **Core Data** with no third-party dependencies.

## Features

- **Course & semester planning.** Add courses to a semester and view them in a
  planner; onboarding captures semester dates on first launch.
- **Study session logging.** Record sessions with a topic, date, and duration,
  linked to the course they belong to.
- **Analytics.** Summarizes total logged sessions and total study time.
- **Pomodoro timer.** Start, pause, reset, and resume a countdown for the selected
  session. A local notification is scheduled for the remaining duration and is
  cancelled when the timer is paused or reset.
- **Offline-first.** Everything is stored locally in Core Data; there is no
  account, network dependency, or backend.

## Data model

Three Core Data entities:

| Entity | Fields | Relationships |
|---|---|---|
| Course | `id`, `name`, `semester` | has many → `Session` |
| Session | `id`, `topic`, `date`, `duration` | belongs to → `Course` |
| Semester | `id`, `name` | — |

Sessions are fetched and aggregated with `NSFetchRequest` for the analytics view.

## Project structure

```text
Final Project/
├── App/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Controllers/
│   ├── OnboardingViewController.swift
│   ├── DashboardViewController.swift
│   ├── PlannerViewController.swift
│   ├── CourseDetailViewController.swift
│   ├── AddSessionViewController.swift
│   ├── AnalyticsViewController.swift
│   └── PomodoroViewController.swift
├── Resources/
└── Final_Project.xcdatamodeld/
```

## Running locally

The current target is configured for **iOS 17.6+**.

```bash
open "Final Project.xcodeproj"
```

Build and run on a simulator or device. Allow notifications when prompted if you
want Pomodoro completion alerts.

## Notes

- Core Data provides all persistence locally on-device.
- The project currently does not include an automated test target, so changes are
  validated through Xcode builds and manual simulator testing.
- The Xcode project still uses its original internal target name, `Final Project`;
  the public repository/project name is StudySync.

## Tech

Swift · UIKit · Core Data · UserNotifications · MVC
