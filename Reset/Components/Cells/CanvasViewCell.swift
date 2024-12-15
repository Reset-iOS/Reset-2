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
    
    @IBOutlet weak var placeHolderText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        canvasCardView.layer.cornerRadius = 20
        canvasCardView.layer.masksToBounds = true
        
        
    }
    
    func configureCellWithoutImages(){
        placeHolderText.isHidden = false
    }
    
    func configureCell(imageOneString: String, imageTwoString: String, imageThreeString: String) {
        imageThree.image = UIImage(named: imageThreeString)
        imageTwo.image = UIImage(named: imageTwoString)
        imageOne.image = UIImage(named: imageOneString)
        placeHolderText.isHidden = true
    }

}
