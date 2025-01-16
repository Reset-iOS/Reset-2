//
//  SupportViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 14/12/24.
//

import UIKit

class SupportViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        
        supportCollectionView.register(UINib(nibName: "SupportChatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SupportCell")
        
        // Setup layout for full-width cells
        if let layout = supportCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.itemSize = CGSize(width: view.frame.width, height: 62) // Match screen width
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        // Refresh the support array
        support = ContactManager.shared.support
        print("Support Array: \(support)")
        
        // Update UI based on support count
        if support.isEmpty {
            addSupportBtn.isHidden = false
            emptySupportText.isHidden = false
            supportCollectionView.isHidden = true
            emptySupportText.text = "No support members yet."
            navigationItem.rightBarButtonItem = nil
        } else {
            addSupportBtn.isHidden = true
            emptySupportText.isHidden = true
            supportCollectionView.isHidden = false
            
            let addSupportItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSupportTapped))
            navigationItem.rightBarButtonItem = addSupportItem
        }
        
        supportCollectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let layout = supportCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: view.frame.width, height: 62) // Ensure full width
        }
    }
    
    @objc func addSupportTapped() {
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let contactsVC = storyboard.instantiateViewController(identifier: "Search") as! ContactsViewController
        navigationController?.pushViewController(contactsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return support.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SupportCell", for: indexPath) as? SupportChatCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.row < support.count {
            cell.configure(with: support[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ChatViewController()
        vc.user = ContactManager.shared.support[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

