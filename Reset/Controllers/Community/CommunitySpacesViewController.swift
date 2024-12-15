//
//  CommunitySpacesViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 04/12/24.
//

import UIKit

class CommunitySpacesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
   
    var spaces: [Space] = []
    @IBOutlet weak var spacesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spacesCollectionView.delegate = self
        spacesCollectionView.dataSource = self
        spacesCollectionView.register(UINib(nibName: "SpacesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SpaceCell")
        spaces = SpacesDataPersistence.shared.loadSpaces()
        spacesCollectionView.showsVerticalScrollIndicator = false

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        spaces = SpacesDataPersistence.shared.loadSpaces()
        spacesCollectionView.reloadData()
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
        cell.configureCell(space: spaces[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height:400) // Adjust height as needed
        }
    

}
