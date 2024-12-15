//
//  ViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 27/11/24.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let progressData = [
        (title: "Bronze", days: "30 Days", iconName: "rosette"),
        (title: "Silver", days: "60 Days", iconName: "rosette"),
        (title: "Gold", days: "100 Days", iconName: "rosette"),
        (title: "Platinum", days: "150 Days", iconName: "rosette")
        ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        // Do any additional setup after loading the view.
    }
    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return progressData.count
        }
    
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgressMedalCollectionViewCell", for: indexPath) as! ProgressMedalCollectionViewCell
            let data = progressData[indexPath.item]
        cell.configure(title: data.title, days: data.days, iconName: data.iconName)
            return cell
        }


}
extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 40
        let height: CGFloat = 100
        return CGSize(width: width, height: height)
    
}
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16 // Spacing between rows
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // No spacing between items in the same row
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) // Section padding
    }


}
