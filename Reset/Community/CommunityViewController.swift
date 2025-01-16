//
//  CommunityViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 04/12/24.
//

import UIKit

class CommunityViewController: UIViewController {
    
    var placeholderContainerView: UIView!
    var currentChildViewController: UIViewController?
    var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view background color
        view.backgroundColor = .white
        
        // Create and configure the segmented control
        segmentedControl = UISegmentedControl(items: ["Posts", "Spaces"])
        segmentedControl.selectedSegmentIndex = 0  // Default segment
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        // Set navigation title
        navigationItem.titleView = segmentedControl
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .systemBrown
        navigationItem.rightBarButtonItem = addButton
        // Add the Add button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        // Create and add the container view
        placeholderContainerView = UIView()
        placeholderContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderContainerView)
        
        // Layout constraints for placeholderContainerView
        NSLayoutConstraint.activate([
            placeholderContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            placeholderContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholderContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Show the "Community Posts" view by default
        segmentedControlValueChanged(segmentedControl)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            // Show the "Community Posts" content
            switchToViewController(withIdentifier: "Community Posts")
        case 1:
            // Show the "Community Spaces" content
            switchToViewController(withIdentifier: "Community Spaces")
        default:
            break
        }
    }
    
    func switchToViewController(withIdentifier identifier: String) {
        let newViewController: UIViewController
        
        switch identifier {
        case "Community Posts":
            // Instantiate CommunityPostsViewController programmatically
            newViewController = CommunityPostsViewController()
        case "Community Spaces":
            // Instantiate the view controller for Community Spaces
            let storyboard = UIStoryboard(name: "Community", bundle: nil)
            newViewController = storyboard.instantiateViewController(withIdentifier: "CommunitySpacesViewController")
        default:
            return
        }
        
        // Remove the current child view controller if there is one
        if let currentVC = currentChildViewController {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }
        
        // Add the new child view controller to the container view
        addChild(newViewController)
        newViewController.view.frame = placeholderContainerView.bounds
        placeholderContainerView.addSubview(newViewController.view)
        newViewController.didMove(toParent: self)
        
        // Update the current child reference
        currentChildViewController = newViewController
    }
    
    @objc func addButtonTapped() {
        // Check which segment is selected and show the appropriate view controller
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            // Show the view controller for "Community Posts"
            let newVC = UploadPostViewController()
            present(newVC, animated: true)
        case 1:
            // Show the view controller for "Community Spaces"
//            let storyboard = UIStoryboard(name: "Community", bundle: nil)
//            let newVC = storyboard.instantiateViewController(withIdentifier: "AddSpaceViewController")
//            navigationController?.pushViewController(newVC, animated: true)
            let newVC = AddSpaceViewController()
            newVC.presentAsHalfSheet(from: self)
        default:
            break
        }
    }
}

