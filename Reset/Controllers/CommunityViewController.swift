//
//  CommunityViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 04/12/24.
//

import UIKit

class CommunityViewController: UIViewController {

    @IBOutlet weak var placeholderContainerView: UIView!
    var currentChildViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Step 1: Create the Title and Subtitle
            let titleLabel = UILabel()
            titleLabel.text = "Summary"
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            titleLabel.textColor = .black

            let subtitleLabel = UILabel()
            subtitleLabel.text = "Friday 22 Nov"
            subtitleLabel.font = UIFont.systemFont(ofSize: 14)
            subtitleLabel.textColor = .gray

            // Stack View for Title and Subtitle
            let titleStackView = UIStackView(arrangedSubviews: [subtitleLabel, titleLabel])
            titleStackView.axis = .vertical
            titleStackView.spacing = 0
            titleStackView.alignment = .leading

            

            // Step 2: Add the Profile Image
            let profileImage = UIImageView(image: UIImage(named: "Emily"))
            profileImage.contentMode = .scaleAspectFill
            profileImage.layer.cornerRadius = 20 // Circular image
            profileImage.clipsToBounds = true
            profileImage.translatesAutoresizingMaskIntoConstraints = false
            profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true

            // Wrap the image in a UIBarButtonItem
            let profileButton = UIBarButtonItem(customView: profileImage)

            // Add the profile image to the right side of the navigation bar
            navigationItem.rightBarButtonItem = profileButton
            
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        // Handle the segmented control value change
        switch sender.selectedSegmentIndex {
        case 0:
            // Show the "Community" content
            switchToViewController(withIdentifier: "Community Posts")
        case 1:
            // Show the "Support" content
            switchToViewController(withIdentifier: "Community Spaces")
        default:
            break
        }
    }
    
    func switchToViewController(withIdentifier identifier: String) {
        // Get the new view controller
        let newViewController = storyboard?.instantiateViewController(withIdentifier: identifier)
        
        guard let newVC = newViewController else { return }
        
        // Remove the current child view controller
        if let currentVC = currentChildViewController {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }
        
        // Add the new child view controller to the container view
        addChild(newVC)
        newVC.view.frame = placeholderContainerView.bounds
        placeholderContainerView.addSubview(newVC.view)
        newVC.didMove(toParent: self)
        
        // Update the current child reference
        currentChildViewController = newVC
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
