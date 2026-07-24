//
//  ViewController.swift
//  Final Project
//
//  Created by Sindhoora on 3/6/26.
//

import UIKit

class OnboardingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        semesterPicker.delegate = self
        semesterPicker.dataSource = self
    }
    
    @IBOutlet weak var semesterPicker: UIPickerView!
    let semesters = ["Fall 2026", "Winter 2026", "Spring 2027", "Summer 2027"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return semesters.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return semesters[row]
    }
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var continueBtn: UIButton!
    @IBAction func continueTapped(_ sender: UIButton) {
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        
        // Save dates
        UserDefaults.standard.set(startDate, forKey: "semesterStartDate")
        UserDefaults.standard.set(endDate, forKey: "semesterEndDate")
        
        // Navigate to tab bar controller
        performSegue(withIdentifier: "goToMainTabs", sender: nil)
        
        let selectedRow = semesterPicker.selectedRow(inComponent: 0)
        let selectedSemester = semesters[selectedRow]
        
        UserDefaults.standard.set(selectedSemester, forKey: "selectedSemester")
    }
}

