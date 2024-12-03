//
//  CanvasViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 03/12/24.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class CanvasViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let model = Model()
    
    func setupCollectionView(){
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        
        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = layout
    }
    
    func registerNibs(){
        let viewNib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        collectionView.register(viewNib, forCellWithReuseIdentifier: "UIImageCollectionViewCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UIImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.image.image = model.images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageSize = model.images[indexPath.item].size
        print(imageSize)
        return imageSize
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupCollectionView()
        registerNibs()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update data source array to reflect the move
        let movedItem = model.images.remove(at: sourceIndexPath.item)
        model.images.insert(movedItem, at: destinationIndexPath.item)
    }

    // MARK: - Long Press Gesture Handler

    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { break }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)

        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))

        case .ended:
            collectionView.endInteractiveMovement()

        default:
            collectionView.cancelInteractiveMovement()
        }
    }

}
