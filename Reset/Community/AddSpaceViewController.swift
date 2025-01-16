//
//  AddSpaceViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 06/01/25.
//

import UIKit
import FirebaseFirestore

class AddSpaceViewController: UIViewController, UITextFieldDelegate {

    // Define UI elements
    var scrollView: UIScrollView!
    var contentView: UIView!
    var spaceTitleTextField: UITextField!
    var spaceDescriptionTextField: UITextField!
    var createSpaceButton: UIButton!
    var goLiveLabel: UILabel!
    var goLiveSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Initial setup
        createSpaceButton.isEnabled = false
        createSpaceButton.backgroundColor = .systemGray // Disabled color
        spaceTitleTextField.delegate = self
        spaceDescriptionTextField.delegate = self

        // Add keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        // Remove keyboard observers
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        // ScrollView
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // ContentView inside ScrollView
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Space Title Text Field
        spaceTitleTextField = createPaddedTextField(placeholder: "Enter space title")
        spaceTitleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        spaceTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spaceTitleTextField)
        
        // Space Description Text Field
        spaceDescriptionTextField = createPaddedTextField(placeholder: "Enter space description")
        spaceDescriptionTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        spaceDescriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spaceDescriptionTextField)
        
        // Go Live Label
        goLiveLabel = UILabel()
        goLiveLabel.text = "Go Live Now"
        goLiveLabel.font = UIFont.systemFont(ofSize: 16)
        goLiveLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(goLiveLabel)
        
        // Go Live Toggle (UISwitch)
        goLiveSwitch = UISwitch()
        goLiveSwitch.addTarget(self, action: #selector(goLiveSwitchToggled), for: .valueChanged)
        goLiveSwitch.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(goLiveSwitch)
        
        // Create Space Button
        createSpaceButton = UIButton(type: .system)
        createSpaceButton.setTitle("Create Space", for: .normal)
        createSpaceButton.setTitleColor(.white, for: .normal)
        createSpaceButton.backgroundColor = UIColor.systemBrown
        createSpaceButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        createSpaceButton.layer.cornerRadius = 10
        createSpaceButton.translatesAutoresizingMaskIntoConstraints = false
        createSpaceButton.addTarget(self, action: #selector(createSpaceButtonTapped), for: .touchUpInside)
        contentView.addSubview(createSpaceButton)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Space Title Text Field
            spaceTitleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            spaceTitleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            spaceTitleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            spaceTitleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Space Description Text Field
            spaceDescriptionTextField.topAnchor.constraint(equalTo: spaceTitleTextField.bottomAnchor, constant: 20),
            spaceDescriptionTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            spaceDescriptionTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            spaceDescriptionTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Go Live Label
            goLiveLabel.topAnchor.constraint(equalTo: spaceDescriptionTextField.bottomAnchor, constant: 20),
            goLiveLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            // Go Live Toggle
            goLiveSwitch.centerYAnchor.constraint(equalTo: goLiveLabel.centerYAnchor),
            goLiveSwitch.leadingAnchor.constraint(equalTo: goLiveLabel.trailingAnchor, constant: 10),
            
            // Create Space Button
            createSpaceButton.topAnchor.constraint(equalTo: goLiveLabel.bottomAnchor, constant: 20),
            createSpaceButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            createSpaceButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createSpaceButton.heightAnchor.constraint(equalToConstant: 50),
            createSpaceButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    private func createPaddedTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.font = UIFont.systemFont(ofSize: 16)
        
        // Add padding using left view
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }

    // MARK: - Keyboard Handling
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        // Adjust content inset to keep text fields visible
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        // Reset content inset
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc func textFieldDidChange() {
        // Enable or disable the button based on text field values
        let isTitleEmpty = spaceTitleTextField.text?.isEmpty ?? true
        let isDescriptionEmpty = spaceDescriptionTextField.text?.isEmpty ?? true
        createSpaceButton.isEnabled = !isTitleEmpty && !isDescriptionEmpty
        createSpaceButton.backgroundColor = createSpaceButton.isEnabled ? .systemBrown : .systemGray
    }
    
    @objc private func goLiveSwitchToggled(_ sender: UISwitch) {
        print("Go Live Now is \(sender.isOn ? "ON" : "OFF")")
    }

    // MARK: - Button Action
    @objc func createSpaceButtonTapped() {
        guard let title = spaceTitleTextField.text,
              let description = spaceDescriptionTextField.text,
              !title.isEmpty, !description.isEmpty else {
            return
        }
        
        let newSpace = Space(
            title: title,
            host: "DefaultHost", // Replace with actual host name
            description: description,
            listenersCount: 0,
            liveDuration: goLiveSwitch.isOn ? "Live" : "Not Live"
        )
        
        // Add to Firestore
        let db = Firestore.firestore()
        db.collection("spaces").addDocument(data: [
            "title": newSpace.title,
            "host": newSpace.host,
            "description": newSpace.description,
            "listenersCount": newSpace.listenersCount,
            "liveDuration": newSpace.liveDuration
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Space added successfully")
                
                // Post notification with new space data
                NotificationCenter.default.post(name: NSNotification.Name("Space Created"), object: newSpace)
                
                // Dismiss the modal
                self.dismiss(animated: true)
            }
        }
    }
    func presentAsHalfSheet(from presentingVC: UIViewController) {
        // Configure the AddSpaceViewController
        let addSpaceVC = AddSpaceViewController()
        addSpaceVC.modalPresentationStyle = .pageSheet
        
        // Configure the sheet presentation controller
        if let sheet = addSpaceVC.sheetPresentationController {
            let customHeight = UISheetPresentationController.Detent.custom { context in
                return 300 // Set your desired height
            }
            
            sheet.detents = [customHeight] // Use the custom detent
            sheet.prefersGrabberVisible = true // Show the grabber handle for dragging
            sheet.preferredCornerRadius = 20   // Optional: Customize corner radius
        }
        
        // Present the view controller
        presentingVC.present(addSpaceVC, animated: true, completion: nil)
    }
    
}
