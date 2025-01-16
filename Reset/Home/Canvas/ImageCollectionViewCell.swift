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
    @IBOutlet weak var deleteButton: UIButton!
    var deleteAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
    }
    @IBAction func deleteItem(_ sender: Any) {
        deleteAction?()
    }
    
}
