//
//  AddSessionViewController.swift
//  Final Project
//
//  Created by Sindhoora on 3/7/26.
//

import UIKit
import CoreData

class AddSessionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Study Session"
        
        // Duration picker settings
        durationPicker.datePickerMode = .countDownTimer
        datePicker.preferredDatePickerStyle = .compact
    }
    
    var course: Course?
    
    let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext
    
    @IBOutlet weak var topicTextField: UITextField!

    @IBOutlet weak var durationPicker: UIDatePicker!
    
    @IBAction func saveSessionTapped(_ sender: UIButton) {
        guard let topic = topicTextField.text, !topic.isEmpty else {
            print("Topic required")
            return
        }
        
        let durationMinutes = Int(durationPicker.countDownDuration / 60)
        let newSession = Session(context: context)
        
        // create new session and link it to course
        newSession.id = UUID()
        newSession.topic = topic
        newSession.duration = Int32(durationMinutes)
        newSession.date = datePicker.date
        newSession.course = course
        
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to save session")
        }
    }

    @IBOutlet weak var datePicker: UIDatePicker!
}
