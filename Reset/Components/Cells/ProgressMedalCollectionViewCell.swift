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
        MedalImage.tintColor = .systemYellow
        }
}