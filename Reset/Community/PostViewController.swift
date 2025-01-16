//
//  PostViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 06/01/25.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class PostViewController: UIViewController, UITextViewDelegate {
    
    var imageToPost: UIImage? // Image passed from the previous controller
    var uploadPostViewController: UploadPostViewController?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let textBox: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 8
        textView.textColor = .lightGray // Set placeholder color
        textView.text = "Write a caption..." // Placeholder text
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
    private var originalY: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(imageView)
        view.addSubview(textBox)
        view.addSubview(postButton)
        
        setupUI()
        imageView.image = imageToPost
        
        textBox.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        postButton.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
    }
    
    func setupUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textBox.translatesAutoresizingMaskIntoConstraints = false
        postButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            textBox.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            textBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textBox.heightAnchor.constraint(equalToConstant: 150),
            
            postButton.topAnchor.constraint(equalTo: textBox.bottomAnchor, constant: 16),
            postButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            postButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            postButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func postButtonTapped() {
        guard let image = imageToPost, let caption = textBox.text, !caption.isEmpty else {
            // Alert user if no image or caption
            showAlert(message: "Please add an image and a caption to post.")
            return
        }
        
        // Upload image to Firebase Storage and get the URL
        uploadImage(image) { [weak self] imageUrl in
            guard let imageUrl = imageUrl else {
                self?.showAlert(message: "Failed to upload image.")
                return
            }
            
            // Save post data to Firestore
            self?.savePostToFirestore(imageUrl: imageUrl, caption: caption)
        }
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        // Convert image to data
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            completion(nil)
            return
        }
        
        // Create a reference to Firebase Storage
        let storageRef = Storage.storage().reference().child("posts/\(UUID().uuidString).jpg")
        
        // Upload image to Firebase Storage
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Get the download URL after the upload completes
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error getting image URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                completion(url?.absoluteString)
            }
        }
    }
    
    func savePostToFirestore(imageUrl: String, caption: String) {
        guard let userID = Auth.auth().currentUser?.uid else {
            showAlert(message: "Unable to fetch user ID.")
            return
        }

        let db = Firestore.firestore()
        let postRef = db.collection("posts").document()

        // Create a post dictionary
        let postData: [String: Any] = [
            "postID": postRef.documentID,
            "userID": userID,
            "imageUrl": imageUrl,
            "caption": caption,
            "timestamp": Timestamp(),
            "likes": 0,
            "comments": 0
        ]

        // Save post to Firestore
        postRef.setData(postData) { [weak self] error in
            if let error = error {
                self?.showAlert(message: "Failed to save post: \(error.localizedDescription)")
                return
            }

            // Successfully saved, notify user
            self?.showAlert(message: "Post successfully added!") {
                NotificationCenter.default.post(name: NSNotification.Name("PostUploaded"), object: nil)
                self?.dismiss(animated: true, completion: {
                    // Dismiss UploadPostViewController using the reference
                    self?.uploadPostViewController?.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Post", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
    
    // MARK: - Keyboard Notification Methods
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            originalY = view.frame.origin.y
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = self.originalY
        }
    }
    
    @objc func dismissKeyboard() {
        textBox.resignFirstResponder()
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a caption..."
            textView.textColor = .lightGray
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


