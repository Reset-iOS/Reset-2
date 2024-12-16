//
//  SignUpViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 16/12/24.
//

import UIKit

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var selectedImage: UIImage?
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var placeHolderLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add tap gesture to dismiss keyboard when tapped outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Add observers for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(imageTapGesture)
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.layer.masksToBounds = true
        let stepLabelButton = UIBarButtonItem(title: "1 of 2", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = stepLabelButton
        
        // Do any additional setup after loading the view.
    }
    // MARK: - Keyboard Handling
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // Get the keyboard size from the notification
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            // Adjust the view's frame to move up (adjust the Y value)
            let keyboardHeight = keyboardFrame.height
            var viewFrame = self.view.frame
            if self.view.frame.origin.y == 0 {
                viewFrame.origin.y -= keyboardHeight
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.frame = viewFrame
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        // Reset the view's frame when the keyboard is dismissed
        var viewFrame = self.view.frame
        if self.view.frame.origin.y != 0 {
            viewFrame.origin.y = 0
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame = viewFrame
        }
    }

    // MARK: - Dismissing Keyboard

    @objc func dismissKeyboard() {
        // Dismiss keyboard when tapping outside of text fields
        view.endEditing(true)
    }
    
    // This method is called when the profile image is tapped
    @objc func profileImageTapped() {
        let actionSheet = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        // Check if the camera is available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                self.openImagePicker(sourceType: .camera)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { _ in
            self.openImagePicker(sourceType: .photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    // Open image picker with a specific source type
    func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }

    // Delegate method to handle the selected image
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            profileImage.image = image
            placeHolderLabel.isHidden = true
        }
        picker.dismiss(animated: true, completion: nil)
    }

    // Delegate method to handle cancelation of image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        // Create a new Contact object using the text fields (or placeholders)
        let name = nameTextField.text ?? "Placeholder Name"
        let email = emailTextField.text ?? "placeholder@example.com"
        let phone = "Placeholder Phone" // Default or empty
        let age = 25 // Placeholder age
        let joinDate = Date().description // Placeholder date
        let soberDuration = "0 weeks" // Placeholder
        let soberSince = Date().description // Placeholder
        let numOfResets = 0 // Placeholder
        let longestStreak = 0 // Placeholder
        let daysPerWeek = 0
        let averageSpend = 0
        
        // Get the profile image path (if selected)
        var profileImagePath = "Placeholder Profile" // Default placeholder
        
        if let selectedImage = selectedImage {
            profileImagePath = ContactManager.shared.saveImage(image: selectedImage) // Save image and get path
        }

        // Create the new Contact object
        let newContact = Contact(name: name, phone: phone, email: email, profile: profileImagePath, age: age, joinDate: joinDate, soberDuration: soberDuration, soberSince: soberSince, numOfResets: numOfResets, longestStreak: longestStreak, daysPerWeek: daysPerWeek, averageSpend: averageSpend)

        // Pass the new contact to the next view controller
//        performSegue(withIdentifier: "showNextVC", sender: newContact)
    let storyboard = UIStoryboard(name: "Entry", bundle: nil)
        if let finalSignUpVC = storyboard.instantiateViewController(withIdentifier: "FinalSignUp") as? FinalSignUpViewController {
            // Pass the Contact object to the FinalSignUpViewController
            finalSignUpVC.contact = newContact

            // Push FinalSignUpViewController onto the navigation stack
            self.navigationController?.pushViewController(finalSignUpVC, animated: true)
        } else {
            print("Failed to instantiate FinalSignUpViewController")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showNextVC",
//            let destinationVC = segue.destination as? FinalSignUpViewController {
//            if let contact = sender as? Contact {
//                destinationVC.contact = contact
//            }
//        }
//    }
    

}
