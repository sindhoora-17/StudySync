//
//  CourseDetailViewController.swift
//  Final Project
//
//  Created by Sindhoora on 3/7/26.
//

import UIKit
import CoreData

class CourseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set background and table styling
        view.backgroundColor = UIColor(named: "BackgroundGray")
        
        tableView.backgroundColor = UIColor(named: "BackgroundGray")
        title = course?.name
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        // load sessions for selected course
        fetchSessions()
        
        // add "Add Session" button in nav bar
        let button = UIBarButtonItem(title: "Add Session", style: .plain, target: self, action: #selector(addSessionTapped))
        button.setTitleTextAttributes([.font: UIFont(name: "MarkerFelt-Wide", size: 18)!, .foregroundColor: UIColor(named: "PrimaryBlue")! ], for: .normal)
        
        navigationItem.rightBarButtonItem = button
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchSessions()
        updateCourseStats()
    }
    
    var course: Course?
    var sessions: [Session] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableView: UITableView!
    
    func fetchSessions() {
        guard let course = course else { return }
        
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        request.predicate = NSPredicate(format: "course == %@", course)
        
        do {
            sessions = try context.fetch(request)
            tableView.reloadData()
            
            // show message if no sessions are available
            if sessions.isEmpty {
                let label = UILabel()
                label.text = "No sessions yet.\nTap 'Add Session' to create one."
                label.textAlignment = .center
                label.numberOfLines = 2
                label.textColor = .secondaryLabel
                
                tableView.backgroundView = label
                
            }
            else {
                tableView.backgroundView = nil
            }
            
        }
        catch {
            print("Failed to fetch sessions")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "sessionCell")
        let session = sessions[indexPath.row]
        
        // display session topic
        cell.textLabel?.text = session.topic
        
        if let date = session.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "E MMM d, h:mm a"
            cell.detailTextLabel?.text = formatter.string(from: date)
        }

        // apply custom styling
        cell.textLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 20)
        cell.detailTextLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 14)
        
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.textColor = .darkGray
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = UIColor(
            red: 255/255,
            green: 198/255,
            blue: 147/255,
            alpha: 1
        )
 
        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.contentView.layer.cornerRadius = 16
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSession = sessions[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let timerVC = storyboard.instantiateViewController(withIdentifier: "PomodoroViewController") as! PomodoroViewController
        
        timerVC.session = selectedSession
        navigationController?.pushViewController(timerVC, animated: true)
    }
    
    @objc func addSessionTapped() {
        performSegue(withIdentifier: "goToAddSession", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddSession" {
            let destination = segue.destination as! AddSessionViewController
            destination.course = course
        }
    }
    
    @IBOutlet weak var pomodoroCountLabel: UILabel!
    
    @IBOutlet weak var totalStudyTimeLabel: UILabel!
    
    func updateCourseStats() {
        let totalSessions = sessions.count
        pomodoroCountLabel.text = "\(totalSessions) Pomodoro sessions completed"
        let totalMinutes = sessions.reduce(0) { $0 + Int($1.duration) }
        let hours = totalMinutes / 60
        totalStudyTimeLabel.text = "\(hours) hr study time completed"
    }
}
