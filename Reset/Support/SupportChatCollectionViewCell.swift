//
//  SupportChatCollectionViewCell.swift
//  Reset
//
//  Created by Prasanjit Panda on 14/12/24.
//

import UIKit

class SupportChatCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.masksToBounds = true
        
    }
    
    func configure(with model: Contact) {
        print(model)
        userName.text = model.name
        profileImage.image = UIImage(named: model.profile)
    }

}
