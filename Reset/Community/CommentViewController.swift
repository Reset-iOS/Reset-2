////
////  CommentViewController.swift
////  Reset
////
////  Created by Prasanjit Panda on 14/12/24.
////
//
//import UIKit
//
//class CommentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    
//    
//    @IBOutlet weak var commentsCollectionView: UICollectionView!
//    @IBOutlet weak var commentTextField: UITextField!
//    @IBOutlet weak var commentInputContainer: UIView!
//    
//    var selectedPost: Post!
//    var onNewComment: ((Comment) -> Void)?
//    var comments: [Comment] = []
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        commentsCollectionView.delegate = self
//        commentsCollectionView.dataSource = self
//        commentsCollectionView.reloadData()
//        setupKeyboardHandling()
//        print(selectedPost!)
//        comments = selectedPost.comments
//        commentsCollectionView.register(UINib(nibName: "CommentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CommentCell")
//        
//        // Do any additional setup after loading the view.
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        commentsCollectionView.reloadData()
//    }
//    
//    override func viewIsAppearing(_ animated: Bool) {
//        commentsCollectionView.reloadData()
//    }
//
//    @IBAction func sendButtonTapped(_ sender: UIButton) {
//        // Ensure the comment text is not empty
//        guard let commentText = commentTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
//              !commentText.isEmpty else {
//            return
//        }
//
//        // Create a new comment
//        let newComment = Comment(
//            id: UUID(),
//            postID: selectedPost.id, // Use the current post's UUID
//            userName: "Emily", // Replace with the actual user's name
//            profileImage: "Emily", // Replace with the actual user's profile image
//            commentText: commentText
//        )
//
//        // Persist the comment using PostDataPersistence
//        PostDataPersistence.shared.addComment(toPostWithID: selectedPost.id, comment: newComment)
//
//        // Reload the comments for the current post
//        if let postIndex = mockPosts.firstIndex(where: { $0.id == selectedPost.id }) {
//            comments = mockPosts[postIndex].comments
//            commentsCollectionView.reloadData()
//        }
//
//        commentsCollectionView.reloadData()
//        // Clear the text field
//        commentTextField.text = ""
//
//        // Dismiss the keyboard
//        commentTextField.resignFirstResponder()
//    }
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        comments.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as! CommentCollectionViewCell
//        
//        let comment = comments[indexPath.row]
//        print(comment)
//        cell.configure(with: comment)
//        
//        return cell
//    }
//    
//    func setupKeyboardHandling() {
//            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//        }
//
//        @objc func keyboardWillShow(notification: NSNotification) {
//            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//            let keyboardHeight = keyboardFrame.height
//            
//            // Adjust the container view to not be overlapped by the keyboard
//            UIView.animate(withDuration: 0.3) {
//                self.commentInputContainer.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
//            }
//        }
//
//        @objc func keyboardWillHide(notification: NSNotification) {
//            UIView.animate(withDuration: 0.3) {
//                self.commentInputContainer.transform = .identity
//            }
//        }
//
//        deinit {
//            NotificationCenter.default.removeObserver(self)
//        }
//
//}
