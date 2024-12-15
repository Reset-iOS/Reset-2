//
//  PostCollectionViewCell.swift
//  Reset
//
//  Created by Prasanjit Panda on 04/12/24.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var dateOfPost: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentsCount: UILabel!
    var commentButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = profileImage.layer.frame.height / 2
        
        // Action for comment button
       commentButton.addTarget(self, action: #selector(commentButtonClicked), for: .touchUpInside)
    }
    
    @objc func commentButtonClicked() {
            commentButtonTapped?()
    }
    
    func configureCell(post: Post) {
        // Setting profile image
       profileImage.image = UIImage(named: post.profileImageName)
       
       // Setting user name and post date
       userName.text = post.userName
       dateOfPost.text = post.dateOfPost
       
       // Setting post text
       postText.text = post.postText
       
       // Setting likes and comments count
       likesCount.text = "\(post.likesCount)"
       commentsCount.text = "\(post.commentsCount)"
       
        if let postImagePath = post.postImageName,
               FileManager.default.fileExists(atPath: postImagePath),
               let savedImage = FileManagerHelper.loadImageFromDisk(imagePath: postImagePath) {
                postImage.image = savedImage
                postImage.isHidden = false
            } else {
                postImage.isHidden = true
        }
    }
}
