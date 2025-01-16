import UIKit
import SkeletonView

class PostCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "PostCollectionViewCell"
    private var isCaptionExpanded = false
    
    // MARK: - UI Components
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .red
        button.setTitle("0", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
     
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        button.tintColor = .gray
        button.setTitle("0", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
      
        return button
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("More...", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.blue, for: .normal)
        
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupCell() {
        contentView.isSkeletonable = true
        [profileImageView, usernameLabel, postImageView, likeButton,
         commentButton, captionLabel, moreButton].forEach {
            contentView.addSubview($0)
            $0.isSkeletonable = true
            if let view = $0 as? UIImageView {
                view.skeletonCornerRadius = 8
            }
        }
        
        setupConstraints()
        moreButton.addTarget(self, action: #selector(toggleCaption), for: .touchUpInside)
        
    }
    
    private func setupConstraints() {
        [profileImageView, usernameLabel, postImageView, likeButton,
         commentButton, captionLabel, moreButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            
            postImageView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalToConstant: 400),
            
            likeButton.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 8),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            commentButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 16),
            
            captionLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 8),
            captionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            captionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            moreButton.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 4),
            moreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            moreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Configuration
    func configure(with post: Post) {
        profileImageView.image = post.profileImage
        usernameLabel.text = post.username
        postImageView.image = post.image
        likeButton.setTitle(" \(post.likeCount)", for: .normal)
        commentButton.setTitle(" \(post.commentCount)", for: .normal)
        captionLabel.text = post.caption
        
        moreButton.isHidden = isCaptionExpanded || post.caption.count <= 50
    }
    
    func prepareForSkeleton() {
        [profileImageView, usernameLabel, postImageView,
         likeButton, commentButton, captionLabel].forEach {
            $0.showAnimatedGradientSkeleton()
        }
    }
    
    @objc private func toggleCaption() {
        isCaptionExpanded.toggle()
        captionLabel.numberOfLines = isCaptionExpanded ? 0 : 2
        moreButton.setTitle(isCaptionExpanded ? "Less..." : "More...", for: .normal)
        // Notify the collection view to reload layout
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
}
