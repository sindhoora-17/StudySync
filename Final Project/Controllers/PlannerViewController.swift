//
//  PlannerViewController.swift
//  Final Project
//
//  Created by Sindhoora on 3/10/26.
//

import UIKit
import CoreData

class PlannerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(named: "BackgroundGray")

        tableView.backgroundColor = UIColor(named: "BackgroundGray")
        
        // set tableview delegates and styling
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        // load sessions from core data
        fetchSessions()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        fetchSessions()
    }
    
    //    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    
    @IBOutlet weak var tableView: UITableView!
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return days.count
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "plannerCell")
        let session = sessions[indexPath.row]
        cell.textLabel?.text = session.topic // display session topic

        if let date = session.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "E MMM d, h:mm a"
            cell.detailTextLabel?.text = formatter.string(from: date)
        }

        // font and background
        cell.textLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 20)
        cell.detailTextLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 14)
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

        // to create vertical spacing between cells
        cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSession = sessions[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let timerVC = storyboard.instantiateViewController(withIdentifier: "PomodoroViewController") as! PomodoroViewController
        
        // navigate to pomodoro timer screen
        timerVC.session = selectedSession
        navigationController?.pushViewController(timerVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var sessions: [Session] = []
    
    func fetchSessions() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let request: NSFetchRequest<Session> = Session.fetchRequest()
            
            // fetch all sessions sorted by date
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            
            sessions = try context.fetch(request)
            tableView.reloadData()
            
        } catch {
            print("Error fetching sessions")
        }
    }
}
