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
        
        
        // Create and configure the segmented control
        let segmentedControl = UISegmentedControl(items: ["Posts", "Spaces"])
        segmentedControl.selectedSegmentIndex = 0  // Default segment
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)

        // Add the segmented control as a UIBarButtonItem
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        segmentedControlValueChanged(segmentedControl)
        
        
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
    
    @objc func addButtonTapped() {
           // Check which segment is selected and show the appropriate view controller
           switch (navigationItem.titleView as? UISegmentedControl)?.selectedSegmentIndex {
           case 0:
               // Show the view controller for "Community Posts"
               let newVC = storyboard?.instantiateViewController(withIdentifier: "AddPostViewController")
               navigationController?.pushViewController(newVC!, animated: true)
           case 1:
               // Show the view controller for "Community Spaces"
               let newVC = storyboard?.instantiateViewController(withIdentifier: "AddSpaceViewController")
               navigationController?.pushViewController(newVC!, animated: true)
           default:
               break
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
