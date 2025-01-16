//
//  SpacesCollectionViewCell.swift
//  Reset
//
//  Created by Prasanjit Panda on 10/12/24.
//

import UIKit

class SpacesCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var spaceTitle: UILabel!
    @IBOutlet weak var spaceStatView: UIView!
    @IBOutlet weak var speakerCountLabel: UILabel!
    @IBOutlet weak var participantCountLabel: UILabel!
    @IBOutlet weak var part2ImageView: UIImageView!
    @IBOutlet weak var part1ImageView: UIImageView!
    @IBOutlet weak var spaceDesc: UILabel!
    @IBOutlet weak var spaceCardView: UIView!
    override func awakeFromNib() {
         super.awakeFromNib()
         // Initialization code
        
         spaceCardView.layer.cornerRadius = 20
         spaceCardView.layer.shadowRadius = 2
         spaceCardView.layer.shadowOpacity = 0.2
         spaceCardView.layer.shadowOffset = CGSize(width: 2, height: 2)
         spaceCardView.translatesAutoresizingMaskIntoConstraints = false
         part1ImageView.layer.cornerRadius = part1ImageView.frame.height / 2
         part1ImageView.layer.masksToBounds = true
         part1ImageView.image = UIImage(named: "Emily")

         part2ImageView.layer.cornerRadius = part2ImageView.frame.height / 2
         part2ImageView.layer.masksToBounds = true
         part2ImageView.image = UIImage(named: "JaneImg")

         spaceStatView.layer.cornerRadius = spaceStatView.frame.height / 2
         spaceStatView.layer.masksToBounds = true
     }

    
     // Configure the cell with data from a Space object
     func configureCell(with space: Space) {
         spaceTitle.text = space.title
         spaceDesc.text = space.description
         participantCountLabel.text = "\(space.listenersCount)"
         
         
         // If you want to use a default image when no image is provided:
         if part1ImageView.image == nil {
             part1ImageView.image = UIImage(named: "onboarding1")
         }
         if part2ImageView.image == nil {
             part2ImageView.image = UIImage(named: "onboarding1")
         }
     }
    
}
