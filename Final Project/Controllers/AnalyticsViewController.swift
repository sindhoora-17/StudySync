//
//  AnalyticsViewController.swift
//  Final Project
//
//  Created by Sindhoora on 3/11/26.
//

import UIKit
import CoreData

class AnalyticsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(named: "BackgroundGray")
        
        totalSessionsLabel.textColor = UIColor(named: "PrimaryBlue")
        totalTimeLabel.textColor = UIColor(named: "PrimaryBlue")
        coursesStudiedLabel.textColor = UIColor(named: "PrimaryBlue")
        
        loadAnalytics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAnalytics()
    }
    
    @IBOutlet weak var totalSessionsLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var coursesStudiedLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func loadAnalytics() {
        do {
            let sessionRequest: NSFetchRequest<Session> = Session.fetchRequest()
            let sessions = try context.fetch(sessionRequest)
            
            // Total sessions
            totalSessionsLabel.text = "Total Sessions: \(sessions.count)"
            
            // Total study time
            let totalMinutes = sessions.reduce(0) { $0 + Int($1.duration) }
            totalTimeLabel.text = "Total Study Time: \(totalMinutes) mins"
            
            // Fetch courses
            let courseRequest: NSFetchRequest<Course> = Course.fetchRequest()
            let courses = try context.fetch(courseRequest)
            
            coursesStudiedLabel.text = "Courses Studied: \(courses.count)"
            
        } catch {
            print("Error loading analytics")
        }
    }
}
