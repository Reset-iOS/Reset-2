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
        
        navigationItem.title = "\(contact!.name)"
        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func addSupportMember(_ sender: UIButton) {
        guard let contact = contact else { return }
            
        // Add the contact to the support array
        ContactManager.shared.support.append(contact)
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
