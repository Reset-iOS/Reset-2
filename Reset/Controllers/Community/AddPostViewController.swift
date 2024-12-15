//
//  AddPostViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 13/12/24.
//

import UIKit

class AddPostViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var postTextField: UITextField!
    @IBOutlet weak var postImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        postButton.isEnabled = false
        postTextField.delegate = self
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        postImage.addGestureRecognizer(tapGesture)
        postImage.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func selectImage(){
        let actionSheet = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openImagePicker(sourceType: .camera)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.openImagePicker(sourceType: .photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet,animated: true, completion: nil)
    }
    
    func openImagePicker(sourceType: UIImagePickerController.SourceType) {
            guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
                let alert = UIAlertController(title: "Error", message: "This source is not available on your device.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            present(imagePicker, animated: true, completion: nil)
        }
        
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                postImage.image = selectedImage
            }
            dismiss(animated: true, completion: nil)
            validatePostButton()
        }
        
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
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
        func textFieldDidChangeSelection(_ textField: UITextField) {
            validatePostButton()
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        // MARK: - Button Validation
        func validatePostButton() {
            let hasText = !(postTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            let hasImage = postImage.image != nil
            postButton.isEnabled = hasText || hasImage
        }
        
        // MARK: - Post Button Action
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let postText = postTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !postText.isEmpty || postImage.image != nil else {
            return
        }
        
        var savedImagePath: String? = nil
        if let image = postImage.image {
            savedImagePath = FileManagerHelper.saveImageToDisk(image)
        }
        
        // Create a new post
        let newPost = Post(
            profileImageName: "Emily", // Replace with actual user data
            userName: "Emily",         // Replace with actual user data
            dateOfPost: getCurrentDateString(),
            postImageName: savedImagePath, // Save file path instead of UIImage
            postText: postText,
            likesCount: 0,
            commentsCount: 0,
            comments: []
        )
        
        print("New post created: \(newPost)")
        mockPosts.append(newPost)
        
        // Show success alert
        let alert = UIAlertController(title: "Success", message: "Your post has been added successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil) // Close the modal
        }))
        present(alert, animated: true, completion: nil)
        
        // Reset UI
        postTextField.text = ""
        postImage.image = nil
        validatePostButton()
    }

        
        // Helper to get current date string
        func getCurrentDateString() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: Date())
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
