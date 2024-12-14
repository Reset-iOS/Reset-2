//
//  CommunityPostsViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 04/12/24.
//

import UIKit


class CommunityPostsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    @IBOutlet weak var postsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        postsCollectionView.showsVerticalScrollIndicator = false
        postsCollectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CommunityPostCell")

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mockPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommunityPostCell", for: indexPath) as! PostCollectionViewCell
        
        let post = mockPosts[indexPath.row]
        cell.configureCell(post: post)
        
        // Set closure for comment button
        cell.commentButtonTapped = { [weak self] in
            self?.openCommentViewController(for: post)
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 280) 
        }
    
    func openCommentViewController(for post: Post) {
            // Assuming you are using a storyboard-based segue to CommentViewController
            
            if let commentVC = storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController {
                commentVC.selectedPost = post
                commentVC.onNewComment = { [weak self] newComment in
                    // Add new comment to post
                    if let index = mockPosts.firstIndex(where: { $0.userName == post.userName }) {
                        mockPosts[index].comments.append(newComment)
                        self?.postsCollectionView.reloadData()
                    }
                }
                
                // Present CommentViewController as a bottom sheet
                commentVC.modalPresentationStyle = .pageSheet
                if let sheet = commentVC.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]  // Set sheet height to medium or large
                }
                present(commentVC, animated: true, completion: nil)
            }
        }
    

}
