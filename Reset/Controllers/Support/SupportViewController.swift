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
        print("Support Array: \(support)")
        
        // Check if the support array is empty or not
        let supportCount = support.count
        
        if supportCount > 0 {
            addSupportBtn.isHidden = true
            supportCollectionView.isHidden = false
            emptySupportText.isHidden = true
            
            let addSupportItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSupportTapped))
            navigationItem.rightBarButtonItem = addSupportItem
        } else {
            addSupportBtn.isHidden = false
            emptySupportText.text = "No support members yet."
            supportCollectionView.isHidden = true
            emptySupportText.isHidden = false
            
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
