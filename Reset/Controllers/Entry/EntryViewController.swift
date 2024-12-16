//
//  EntryViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 16/12/24.
//

import UIKit

class EntryViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = userName.text, !username.isEmpty else {
            showAlert(message: "Please enter a username.")
            return
        }
        
        guard let enteredPassword = password.text, !enteredPassword.isEmpty else {
            showAlert(message: "Please enter a password.")
            return
        }
        
        // Search for the contact with the entered username
        if let contact = ContactManager.shared.contacts.first(where: { $0.name == username }) {
            // Check if the password matches
            if "1234" == enteredPassword {
                // Set the current user
                UserManager.shared.setCurrentUser(contact)
                
                // Navigate to the SuperViewController
                let storyboard = UIStoryboard(name: "Super", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "SuperViewController")
                navigationController?.pushViewController(viewController, animated: true)

            } else {
                // Password doesn't match
                showAlert(message: "Incorrect password.")
            }
        } else {
            // Username not found
            showAlert(message: "User not found.")
        }
        
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
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
