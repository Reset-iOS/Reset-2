//
//  SpacesCollectionViewCell.swift
//  Reset
//
//  Created by Prasanjit Panda on 10/12/24.
//

import UIKit

class SpacesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var spaceTitle: UILabel!
    
    @IBOutlet weak var spaceHost: UILabel!
    
    @IBOutlet weak var spaceTheme: UILabel!
    
    @IBOutlet weak var spaceStats: UILabel!
    
    @IBOutlet weak var spaceCellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        spaceCellView.layer.cornerRadius = 10
        spaceCellView.layer.masksToBounds = true
        
        spaceCellView.layer.shadowColor = UIColor.black.cgColor
        spaceCellView.layer.shadowOpacity = 0.2 // Adjust for lighter shadow
        spaceCellView.layer.shadowOffset = CGSize(width: 0, height: 2) // Shadow below the cell
        spaceCellView.layer.shadowRadius = 4 // Blurred shadow effect
    }
    
    func configureCell(space: Space) {
        spaceTitle.text = space.title
        spaceHost.text = space.host
        spaceTheme.text = space.description
        spaceStats.text = "\(space.listenersCount) listening | Live for \(space.liveDuration) mins"
    }
    

}
