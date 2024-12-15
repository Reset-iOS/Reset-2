//
//  CanvasViewCell.swift
//  Reset
//
//  Created by Prasanjit Panda on 15/12/24.
//

import UIKit

class CanvasViewCell: UICollectionViewCell {

    @IBOutlet weak var imageThree: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var canvasCardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        canvasCardView.layer.cornerRadius = 20
        canvasCardView.layer.masksToBounds = true
        
    }
    
    func configureCell(imageOneString: String, imageTwoString: String, imageThreeString: String) {
        imageThree.image = UIImage(named: imageThreeString)
        imageTwo.image = UIImage(named: imageTwoString)
        imageOne.image = UIImage(named: imageOneString)
    }

}
