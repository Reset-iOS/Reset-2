//
//  DetailViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 04/12/24.
//

import UIKit

class DetailViewController: UIViewController {
        
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var nameAndAgeLabel: UILabel!
    
    @IBOutlet weak var joinDateLabel: UILabel!
    
    @IBOutlet weak var soberDurationLabel: UILabel!
    
    @IBOutlet weak var soberSinceLabel: UILabel!
    
    @IBOutlet weak var numOfResetsLabel: UILabel!
    
    @IBOutlet weak var resetsLabel: UILabel!
    
    @IBOutlet weak var longestStreakValueLabel: UILabel!
    
    @IBOutlet weak var longestStreakLabel: UILabel!
    
    var contact: Contact?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(contact!)
        nameAndAgeLabel.text = "\(contact!.name)"
        longestStreakValueLabel.text = "\(contact!.longestStreak)"
        longestStreakLabel.text = "Longest Streak"
        numOfResetsLabel.text = "\(contact!.numOfResets)"
        resetsLabel.text = "Resets"
        joinDateLabel.text = "\(contact!.joinDate)"
        soberSinceLabel.text = "Sober Since"
        soberDurationLabel.text = "\(contact!.soberDuration)"
        navigationItem.title = "\(contact!.name)"
        userImage.image = UIImage(named: contact!.profile)
        // Convert soberSince to Date and calculate weeks
        if let soberSinceDate = dateFromString(contact!.soberSince) {
            let weeksSinceSober = weeksSince(date: soberSinceDate)
            soberDurationLabel.text = "\(weeksSinceSober) weeks"
        } else {
            soberDurationLabel.text = "Invalid Date"
        }
        

        // Do any additional setup after loading the view.
    }
    
    // Convert string date (yyyy-MM-dd) to Date
       func dateFromString(_ dateString: String) -> Date? {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd"
           return dateFormatter.date(from: dateString)
       }
       
       // Calculate the number of weeks since the given date
       func weeksSince(date: Date) -> Int {
           let currentDate = Date()
           let calendar = Calendar.current
           let components = calendar.dateComponents([.weekOfYear], from: date, to: currentDate)
           return components.weekOfYear ?? 0
       }
    

    @IBAction func addSupportMember(_ sender: UIButton) {
        guard let contact = contact else { return }
        
        // Add the contact to the support array
        if !ContactManager.shared.support.contains(where: { $0.email == contact.email }) {
            ContactManager.shared.support.append(contact)
        }
        
        print(ContactManager.shared.support)
        
        if let supportVC = navigationController?.viewControllers.first(where: { $0 is SupportViewController }) {
            // Pop to SupportViewController and remove all other view controllers
            navigationController?.popToViewController(supportVC, animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
