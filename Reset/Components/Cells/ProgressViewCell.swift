//
//  ProgressViewCell.swift
//  Reset
//
//  Created by Prasanjit Panda on 15/12/24.
//

import UIKit

class ProgressViewCell: UICollectionViewCell {

    @IBOutlet weak var daysSoberOngoing: UILabel!
    
    @IBOutlet weak var medal: UIImageView!
    
    @IBOutlet weak var progressCardView: UIView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var daysToNextMilestone: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        progressCardView.layer.cornerRadius = 20
        progressCardView.layer.masksToBounds = false
        
        // Add shadow to the card view
        progressCardView.layer.shadowColor = UIColor.black.cgColor
        progressCardView.layer.shadowOpacity = 0.25
        progressCardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        // Vertical offset
        progressCardView.layer.shadowRadius = 6 // Blur radius
        progressCardView.layer.shadowPath = UIBezierPath(roundedRect: progressCardView.bounds, cornerRadius: progressCardView.layer.cornerRadius).cgPath
        
        // Optional: to improve performance by not recalculating the shadow every time the cell's bounds change
        progressCardView.layer.shouldRasterize = true
        progressCardView.layer.rasterizationScale = UIScreen.main.scale
        
        progressView.progressTintColor = .black
        daysSoberOngoing.textColor = .black
        daysToNextMilestone.textColor = .black
        
    }
    
    
    func configureCell(daysSoberOngoing: Int, daysToNextMilestone: Int, progress: Double) {
        self.daysSoberOngoing.text = "\(daysSoberOngoing)"
        self.daysToNextMilestone.text = "\(daysToNextMilestone) days to next milestone"
        progressView.progress = Float(progress)
        medal.image = UIImage(systemName: "medal.fill")
        medal.tintColor = .black
        
        // Change background color based on daysSoberOngoing
        switch daysSoberOngoing {
        case 0..<30:
            progressCardView.backgroundColor = .systemRed // Red for less than 30 days
        case 30..<90:
            progressCardView.backgroundColor = .systemYellow // Yellow for 30 to 89 days
        case 90..<365:
            progressCardView.backgroundColor = .systemGreen // Green for 90 to 364 days
        default:
            progressCardView.backgroundColor = .systemBlue// Blue for 1 year and above
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        // Show an alert asking if the user wants to reset
            let alertController = UIAlertController(title: "Confirm Reset", message: "Are you sure you want to reset your sobriety? It's fine to reset and start fresh.", preferredStyle: .alert)
            
            // Add a Cancel action
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            // Add a Reset action
            alertController.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { [weak self] _ in
                self?.resetSobriety()
            }))
            
            // Present the alert
            if let viewController = self.window?.rootViewController {
                viewController.present(alertController, animated: true, completion: nil)
            }
      }
    
    func resetSobriety() {
            // Get the current user from UserManager
            guard let currentUser = UserManager.shared.getCurrentUser() else { return }
            
            // Update the soberSince date to the current date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let currentDate = dateFormatter.string(from: Date())
            
            // Create a new Contact with updated soberSince date
            var updatedUser = currentUser
            updatedUser.soberSince = currentDate
            
            // Save the updated user object
            UserManager.shared.setCurrentUser(updatedUser)
            
            
            // Optionally, notify the user that their reset was successful
            let successAlert = UIAlertController(title: "Reset Successful", message: "Your sobriety date has been reset.", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            if let viewController = self.window?.rootViewController {
                viewController.present(successAlert, animated: true, completion: nil)
            }
    }
      
      // Helper method to find the parent view controller for presenting the alert
      private func findViewController() -> UIViewController? {
          var viewController = self.next
          while viewController != nil {
              if let viewController = viewController as? UIViewController {
                  return viewController
              }
              viewController = viewController?.next
          }
          return nil
    }
    
}
