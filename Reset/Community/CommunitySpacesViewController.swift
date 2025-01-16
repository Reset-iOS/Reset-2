//
//  CommunitySpacesViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 04/12/24.
//

import UIKit
import FirebaseFirestore

class CommunitySpacesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
   
    var spaces: [Space] = []
    @IBOutlet weak var spacesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spacesCollectionView.delegate = self
        spacesCollectionView.dataSource = self
//        spacesCollectionView.backgroundColor = .black
        
        spacesCollectionView.register(UINib(nibName: "SpacesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SpaceCell")
        spaces = SpacesDataPersistence.shared.loadSpaces()
        spacesCollectionView.showsVerticalScrollIndicator = false
        NotificationCenter.default.addObserver(self, selector: #selector(spaceCreated(notification:)), name:NSNotification.Name("Space Created"), object: nil)
        loadSpaces()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        spaces = SpacesDataPersistence.shared.loadSpaces()
        spacesCollectionView.reloadData()
    }
    
    deinit {
        // Remove observer to prevent memory leaks
        NotificationCenter.default.removeObserver(self)
    }

    func loadSpaces() {
        let db = Firestore.firestore()
        db.collection("spaces").getDocuments { snapshot, error in
            if let error = error {
                print("Error loading spaces: \(error)")
                return
            }
            
            
            self.spaces = snapshot?.documents.compactMap { document in
                let data = document.data()
                print(data)
                return Space(
                    title: data["title"] as? String ?? "",
                    host: data["host"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    listenersCount: data["listenersCount"] as? Int ?? 0,
                    liveDuration: data["liveDuration"] as? String ?? ""
                )
            } ?? []
            self.spacesCollectionView.reloadData()
        }
    }

    @objc func spaceCreated(notification: Notification) {
        loadSpaces()
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
        spaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpaceCell", for: indexPath) as! SpacesCollectionViewCell
        cell.configureCell(with: spaces[indexPath.row])
        return cell
    }
//    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 370,height: 400) // Adjust height as needed
        }
    

}
