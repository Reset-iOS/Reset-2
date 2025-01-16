//
//  ChangePhotoViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 08/01/25.
//


import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class ChangePhotoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    private let storage = Storage.storage().reference()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "change your photo"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "onboarding1", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(ChangePhotoViewController.self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75 // Circular image
        imageView.image = UIImage(named: "onboarding1") // Replace with your default image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBrown
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage))
        
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(profileImageView)
        view.addSubview(doneButton)
        profileImageView.addGestureRecognizer(tapGesture)
        doneButton.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
        
        setupConstraints()
    }
    
    @objc private func didTapProfileImage() {
        print("Profile image button tapped")
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker,animated: true)
    }
    
    @objc private func didTapDone() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title label constraints
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Close button constraints
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Profile image view constraints
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150),
            
            // Done button constraints
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            doneButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
//
//    @objc private func didTapDone() {
//
//        // Handle the done button action here
//    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true,completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        
      
        let imageId=UUID().uuidString
        // upload image data
        storage.child("images/\(imageId).png").putData(imageData, metadata: nil) { _ , error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            
            guard let userID = Auth.auth().currentUser?.uid else {
                return
            }
            let db = Firestore.firestore()
            
            
            
            self.storage.child("images/\(imageId).png").downloadURL { url , error in
                guard let url = url, error == nil else {
                    return
                }
                
                
                let urlString = url.absoluteString
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
                db.collection("users").document(userID).updateData(["imageUrl": urlString])
                
                print("urlString: \(urlString)")
                print("userID:\(userID)")
                UserDefaults.standard.set(urlString, forKey: "imageUrl")
            }
        }
        
        // get download url
        
        // save download url to userDefaults
        
        
    }
}
