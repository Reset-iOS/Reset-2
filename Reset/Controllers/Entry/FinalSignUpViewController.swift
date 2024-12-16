//
//  FinalSignUpViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 16/12/24.
//

import UIKit

class FinalSignUpViewController: UIViewController {

    var contact: Contact?
    @IBOutlet weak var averageSpendPerWeekTextField: UITextField!
    @IBOutlet weak var daysPerWeekTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let stepLabelButton = UIBarButtonItem(title: "2 of 2", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = stepLabelButton
        

        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func letsResetButtonTapped(_ sender: UIButton) {
        contact?.daysPerWeek = Int(daysPerWeekTextField.text!) ?? 0
        contact?.averageSpend = Int(averageSpendPerWeekTextField.text!) ?? 0
        
        // Save the current contact as the active user (implementation depends on your app logic)
        if let contact = contact {
            UserManager.shared.setCurrentUser(contact) // Assuming you have a UserManager for managing user data
        }
        
        // Instantiate the SuperViewController
        let storyboard = UIStoryboard(name: "Super", bundle: nil) // Replace "Main" with your storyboard name
        if let superVC = storyboard.instantiateViewController(withIdentifier: "SuperViewController") as? SuperViewController {
            // Reset the navigation stack with the SuperViewController
            let navigationController = self.navigationController
            navigationController?.setViewControllers([superVC], animated: true)
        } else {
            print("Failed to instantiate SuperViewController")
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
