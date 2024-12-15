//
//  AddSpaceViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 14/12/24.
//

import UIKit

class AddSpaceViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var spaceTitleLabel: UILabel!
    @IBOutlet weak var spaceDescriptionTextField: UITextField!
    @IBOutlet weak var spaceDescriptionLabel: UILabel!
    @IBOutlet weak var createSpaceButton: UIButton!
    @IBOutlet weak var spaceTitleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initial setup
       createSpaceButton.isEnabled = false
       spaceTitleTextField.delegate = self
       spaceDescriptionTextField.delegate = self

       // Add keyboard observers
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    
    deinit {
        // Remove keyboard observers
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Keyboard Handling
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            view.frame.origin.y = -keyboardFrame.height / 3 // Adjust as needed
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }

    // MARK: - Text Field Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Validate inputs whenever text changes
        validateCreateSpaceButton()
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - Validate Button
    private func validateCreateSpaceButton() {
        let isTitleValid = !(spaceTitleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let isDescriptionValid = !(spaceDescriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        createSpaceButton.isEnabled = isTitleValid && isDescriptionValid
    }

    // MARK: - Create Space Button Action
    @IBAction func createSpaceButtonTapped(_ sender: UIButton) {
        // Validate input
        guard let title = spaceTitleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let description = spaceDescriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !title.isEmpty, !description.isEmpty else {
            return
        }

        // Create new space
        let newSpace = Space(
            title: title,
            host: "CurrentUser", // Replace with the actual current user's name
            description: description,
            listenersCount: 0, // Default listeners count
            liveDuration: "Starting soon" // Default duration
        )

        // Append to mockSpaces
        mockSpaces.append(newSpace)

        // Show success alert
        let alert = UIAlertController(title: "Space Created", message: "Your space has been created successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil) // Dismiss the view
        }))
        present(alert, animated: true, completion: nil)

        // Reset UI
        spaceTitleTextField.text = ""
        spaceDescriptionTextField.text = ""
        createSpaceButton.isEnabled = false
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
