//
//  ImageCollectionViewCell.swift
//  Reset
//
//  Created by Prasanjit Panda on 03/12/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
    }

}
