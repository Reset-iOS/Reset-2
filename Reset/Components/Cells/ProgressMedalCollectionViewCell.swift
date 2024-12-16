//
//  ProgressMedalCollectionViewCell.swift
//  Reset
//
//  Created by Prasanjit Panda on 15/12/24.
//


//
//  ProgressMedalCollectionViewCell.swift
//  Reset
//
//  Created by Raksha on 02/12/24.
//

import UIKit

class ProgressMedalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var MedalImage: UIImageView!
    
    @IBOutlet weak var MainLabel: UILabel!
    
    @IBOutlet weak var SubLabel: UILabel!
    
    func configure(title: String, days: String, iconName: String) {
        MainLabel.text = title
        SubLabel.text = days
        MedalImage.image = UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate)
        
        // Set text color and icon color based on the title or other criteria
        switch title {
        case "Bronze":
            MainLabel.textColor = .systemRed
            SubLabel.textColor = .systemRed
            MedalImage.tintColor = .systemRed
        case "Silver":
            MainLabel.textColor = .systemYellow
            SubLabel.textColor = .systemYellow
            MedalImage.tintColor = .systemYellow
        case "Gold":
            MainLabel.textColor = .systemGreen
            SubLabel.textColor = .systemGreen
            MedalImage.tintColor = .systemGreen
        case "Platinum":
            MainLabel.textColor = .systemBlue
            SubLabel.textColor = .systemBlue
            MedalImage.tintColor = .systemBlue
        default:
            MainLabel.textColor = .black
            SubLabel.textColor = .black
            MedalImage.tintColor = .gray // Default color
        }

    }
}
