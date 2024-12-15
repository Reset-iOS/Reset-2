//
//  SupportViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 14/12/24.
//

import UIKit

class SupportViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var supportCollectionView: UICollectionView!
    @IBOutlet weak var addSupportBtn: UIButton!
    @IBOutlet weak var emptySupportText: UILabel!
    
    var support = [Contact]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Support"
        supportCollectionView.delegate = self
        supportCollectionView.dataSource = self
        support = ContactManager.shared.support
        // Do any additional setup after loading the view.
        supportCollectionView.register(UINib(nibName: "SupportChatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SupportCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        // Assign support array from ContactManager.shared.support
        support = ContactManager.shared.support
        
        // Check if the support array is empty or not
        let supportCount = support.count
        
        if supportCount > 0 {
            // If there are support members, hide the "Add Support" button and set the label
            addSupportBtn.isHidden = true
            supportCollectionView.isHidden = false
            emptySupportText.isHidden = true
            
            // Add the "Plus" button to the navigation bar
            let addSupportItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSupportTapped))
            navigationItem.rightBarButtonItem = addSupportItem
        } else {
            // If there are no support members, show the "Add Support" button and set the label
            addSupportBtn.isHidden = false
            emptySupportText.text = "No support members yet."
            supportCollectionView.isHidden = true
            emptySupportText.isHidden = false
            
            // Remove the "Plus" button from the navigation bar
            navigationItem.rightBarButtonItem = nil
        }
        
        supportCollectionView.reloadData()
    }
        
    // Action for the "Plus" button in the navigation bar
    @objc func addSupportTapped() {
        // Instantiate the ContactsViewController from the storyboard
        let storyboard = UIStoryboard(name: "Search", bundle: nil) // Replace "Main" with your storyboard name if different
        let contactsVC = storyboard.instantiateViewController(identifier: "Search") as! ContactsViewController
        
        // Push the ContactsViewController onto the navigation stack
        navigationController?.pushViewController(contactsVC, animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ContactManager.shared.support.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SupportCell", for: indexPath) as! SupportChatCollectionViewCell
        if indexPath.row < support.count {
                    cell.configure(with: support[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 361, height: 62)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ChatViewController()
        vc.user = ContactManager.shared.support[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
