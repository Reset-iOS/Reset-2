//
//  CommentCollectionViewCell.swift
//  Reset
//
//  Created by Prasanjit Panda on 14/12/24.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = profileImage.layer.frame.height / 2
        profileImage.layer.masksToBounds = true
    }

    func configure(with comment: Comment) {
        userName.text = comment.userName
        commentText.text = comment.commentText
        profileImage.image = UIImage(named: comment.profileImage)
    }
}


