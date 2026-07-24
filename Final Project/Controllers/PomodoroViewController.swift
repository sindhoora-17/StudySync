//
//  PomodoroViewController.swift
//  Final Project
//
//  Created by Sindhoora on 3/10/26.
//

import UIKit
import UserNotifications

class PomodoroViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(named: "BackgroundGray")
        
        // set UI colors
        timerLabel.textColor = UIColor(named: "PrimaryBlue")
        topicLabel.textColor = UIColor(named: "SecondaryText")
        
        if let session = session {
            topicLabel.text = session.topic
            secondsRemaining = Int(session.duration) * 60
        }
        
        updateTimerLabel()
        
        // request notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
            granted, error in
            if granted {
                print("Notifications allowed")
            }
        }
    }
    
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer: Timer?
    var secondsRemaining = 1500
    var session: Session?
    
    @IBAction func startTapped(_ sender: UIButton) {
        timer?.invalidate()
        // start countdown timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            
            if self.secondsRemaining > 0 {
                self.secondsRemaining -= 1
                self.updateTimerLabel()
            } else {
                self.timer?.invalidate()
                self.showCompletionAlert()
            }
        }
        
        scheduleNotification(minutes: secondsRemaining / 60)
    }
    
    @IBAction func pauseTapped(_ sender: UIButton) {
        timer?.invalidate()
    }
    
    @IBAction func resetTapped(_ sender: UIButton) {
        timer?.invalidate()
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
    
    // sends notification when pomodoro ends
    func scheduleNotification(minutes: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Pomodoro Complete 🍅"
        content.body = "Your study session has finished. Take a break!"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(minutes * 60), repeats: false)
        let request = UNNotificationRequest(identifier: "pomodoroComplete", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
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
