//
//  DashboardViewController.swift
//  Final Project
//
//  Created by Sindhoora on 3/6/26.
//

import UIKit
import CoreData

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundGray")

        navigationController?.navigationBar.tintColor = UIColor(named: "PrimaryBlue")
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(named: "PrimaryBlue")!,
            .font: UIFont(name: "MarkerFelt-Wide", size: 24)!
        ]
        
        if let semester = UserDefaults.standard.string(forKey: "selectedSemester") {
            title = "My Courses - \(semester)"
        } else {
            title = "My Courses"
        }
        
        tableView.backgroundColor = UIColor(named: "BackgroundGray")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        // fetches and displays the courses when the screen loads
        fetchCourses()
        
        // adds a plus button to add a new course
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCourseTapped))
    }
    
    @objc func addCourseTapped() {
        let alert = UIAlertController(title: "Add Course", message: "Enter course name", preferredStyle: .alert)
        alert.addTextField()

        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let textField = alert.textFields?.first,
               let courseName = textField.text,
               !courseName.isEmpty {

                // creates new course object and saves to core data
                let newCourse = Course(context: self.context)
                newCourse.id = UUID()
                newCourse.name = courseName
                
                // save the selected semester using UserDefaults
                if let semester = UserDefaults.standard.string(forKey: "selectedSemester") {
                    newCourse.semester = semester
                }

                do {
                    try self.context.save()
                    self.fetchCourses()
                } catch {
                    print("Failed to save course")
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    var courses: [Course] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath)
        cell.textLabel?.text = courses[indexPath.row].name

        cell.textLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 22)
        cell.textLabel?.textColor = .black
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
    
    func fetchCourses() {
        let request: NSFetchRequest<Course> = Course.fetchRequest()
        if let semester = UserDefaults.standard.string(forKey: "selectedSemester") {
            request.predicate = NSPredicate(format: "semester == %@", semester)
        }

        do {
            courses = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Failed to fetch courses")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCourse = courses[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "CourseDetailViewController") as! CourseDetailViewController

        detailVC.course = selectedCourse
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    @IBOutlet weak var tableView: UITableView!
}
