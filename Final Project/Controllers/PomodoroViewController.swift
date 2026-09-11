//
//  PomodoroViewController.swift
//  Final Project
//
//  Created by Sindhoora on 3/10/26.
//

import UIKit
import UserNotifications

class PomodoroViewController: UIViewController {

    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!

    private let notificationIdentifier = "pomodoroComplete"
    var timer: Timer?
    var secondsRemaining = 1500
    var session: Session?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "BackgroundGray")
        timerLabel.textColor = UIColor(named: "PrimaryBlue")
        topicLabel.textColor = UIColor(named: "SecondaryText")

        if let session = session {
            topicLabel.text = session.topic
            secondsRemaining = Int(session.duration) * 60
        }

        updateTimerLabel()

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    @IBAction func startTapped(_ sender: UIButton) {
        timer?.invalidate()
        cancelPendingNotification()

        guard secondsRemaining > 0 else {
            showCompletionAlert()
            return
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }

            if self.secondsRemaining > 0 {
                self.secondsRemaining -= 1
                self.updateTimerLabel()
            }

            if self.secondsRemaining == 0 {
                self.timer?.invalidate()
                self.cancelPendingNotification()
                self.showCompletionAlert()
            }
        }

        scheduleNotification(after: secondsRemaining)
    }

    @IBAction func pauseTapped(_ sender: UIButton) {
        timer?.invalidate()
        timer = nil
        cancelPendingNotification()
    }

    @IBAction func resetTapped(_ sender: UIButton) {
        timer?.invalidate()
        timer = nil
        cancelPendingNotification()

        if let session = session {
            secondsRemaining = Int(session.duration) * 60
        } else {
            secondsRemaining = 1500
        }

        updateTimerLabel()
    }

    func updateTimerLabel() {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

    private func scheduleNotification(after seconds: Int) {
        guard seconds > 0 else { return }

        let content = UNMutableNotificationContent()
        content.title = "Pomodoro Complete 🍅"
        content.body = "Your study session has finished. Take a break!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(seconds),
            repeats: false
        )
        let request = UNNotificationRequest(
            identifier: notificationIdentifier,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    private func cancelPendingNotification() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
    }

    func showCompletionAlert() {
        let alert = UIAlertController(
            title: "Session Completed! 🎉",
            message: "Great job studying! Time for a break.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
