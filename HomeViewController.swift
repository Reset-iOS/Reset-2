//
//  HomeViewController.swift
//  Reset
//
//  Created by Raksha on 07/01/25.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var circularProgressView: CircularProgressView!
    
    
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set the page background color
            view.backgroundColor = UIColor(red: 255/255, green: 241/255, blue: 227/255, alpha: 1)
            
            // Set the circularProgressView's background to white
            circularProgressView.backgroundColor = .white
            
            // Make the circularProgressView a perfect circle
            circularProgressView.layer.cornerRadius = circularProgressView.frame.width / 2
            circularProgressView.layer.masksToBounds = true
            
            // Set the progress and titles
            circularProgressView.setProgress(0.4, withNumber: 12)
            circularProgressView.setTitle("Bronze league", subtitle: "You are 18 days away from the next milestone")
            
            // Apply 3D effect to circularProgressView
            apply3DEffect(to: circularProgressView)
        
        // Light brown
        
        
        // Set up the progress
        //let progress = Float(12) / 30.0
       
    }
    func apply3DEffect(to view: UIView) {
        // Set the background color to clear for better visibility of shadow
        view.backgroundColor = .white
        
        // Round the corners for a 3D look
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        
        // Add shadow to create depth effect
        view.layer.shadowColor = UIColor.systemGray5.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.12
        view.layer.shadowRadius = 8
        view.layer.masksToBounds = false
        
        // Add subtle border for more depth perception
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor.systemGray5.cgColor
        
        // Optimize shadow rendering
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    
    
    /* func updateButtonColors() {
     // Ensure the LeagueName label text exists
     guard let league = LeagueName.text else { return }
     
     // Define colors for different leagues
     let bronzeColor = UIColor(red: 198/255, green: 145/255, blue: 85/255, alpha: 1)  // Bronze
     let silverColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)  // Silver
     let goldColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)      // Gold
     let crystalColor = UIColor(red: 204/255, green: 153/255, blue: 255/255, alpha: 1) // Crystal
     let rubyColor = UIColor(red: 255/255, green: 55/255, blue: 11/255, alpha: 1)      // Ruby
     let emeraldColor = UIColor(red: 80/255, green: 200/255, blue: 120/255, alpha: 1)  // Emerald
     let defaultColor = UIColor.systemGray                                              // Default color
     
     var color: UIColor
     
     // Match the league name and set the corresponding color
     switch league {
     case "Bronze league":
     color = bronzeColor
     case "Silver league":
     color = silverColor
     case "Gold league":
     color = goldColor
     case "Crystal league":
     color = crystalColor
     case "Ruby league":
     color = rubyColor
     case "Emerald league":
     color = emeraldColor
     default:
     color = defaultColor
     }
     
     // Animate the button color changes
     UIView.animate(withDuration: 0.3) {
     self.MilestonesButton.tintColor = color
     self.ResetButton.tintColor = color
     }
     }
     
     // Example method to change league dynamically
     func changeLeague(to newLeague: String) {
     LeagueName.text = newLeague // Update the league label
     updateButtonColors()        // Update button colors
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
     */
    
}
