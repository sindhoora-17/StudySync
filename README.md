# StudySync — iOS Study Tracker

A native iOS app for planning and tracking study time. Log study sessions against
your courses, see where your time actually goes, and run focused work blocks with
a built-in Pomodoro timer that notifies you even when the app isn't open.

Built with **UIKit** and **Core Data** — no third-party dependencies.

## Features

- **Course & semester planning.** Add courses to a semester and view them in a
  planner; onboarding captures the semester start/end dates on first launch.
- **Study session logging.** Record sessions with a topic, date, and duration,
  linked to the course they belong to.
- **Analytics.** A summary view over all logged sessions showing total session
  count and total study time.
- **Pomodoro timer.** Start/pause/reset a focus timer with a live countdown.
  Because iOS suspends an app's `Timer` in the background, the app also schedules
  a local notification so you still get alerted when the block ends.
- **Offline-first.** Everything is stored locally in Core Data; no account, no
  network, no backend.

## Data model

Three Core Data entities:

| Entity   | Fields                              | Relationships              |
|----------|-------------------------------------|----------------------------|
| Course   | `id`, `name`, `semester`            | has many → `Session`       |
| Session  | `id`, `topic`, `date`, `duration`   | belongs to → `Course`      |
| Semester | `id`, `name`                        | —                          |

Sessions are fetched and aggregated with `NSFetchRequest` for the analytics view.

## Project structure

```
├── App/
│   ├── AppDelegate.swift             Core Data stack + app lifecycle
│   └── SceneDelegate.swift
├── Controllers/
│   ├── OnboardingViewController.swift    first-launch semester setup
│   ├── DashboardViewController.swift     home screen
│   ├── PlannerViewController.swift       course list / planning
│   ├── CourseDetailViewController.swift  a course and its sessions
│   ├── AddSessionViewController.swift    log a study session (Core Data write)
│   ├── AnalyticsViewController.swift     totals over logged sessions
│   └── PomodoroViewController.swift      focus timer + local notifications
└── Final_Project.xcdatamodeld/           Core Data model (Course, Session, Semester)
```

## Running it

Requires Xcode 15+ and iOS 16+.

```bash
open "Final Project.xcodeproj"
```

Then build and run on the simulator or a device. Allow notifications when
prompted so the Pomodoro timer can alert you.

## Tech

Swift · UIKit · Core Data · UserNotifications · MVC