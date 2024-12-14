//
//  CanvasViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 03/12/24.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class CanvasViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let model = Model()
    var editMode = false
    
    func setupCollectionView(){
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTextOrImage))
        navigationItem.rightBarButtonItem = addButton
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditMode))
        navigationItem.leftBarButtonItem = editButton
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = layout
    }
    
    func registerNibs(){
        let viewNib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        collectionView.register(viewNib, forCellWithReuseIdentifier: "UIImageCollectionViewCell")
        
        let textNib = UINib(nibName: "TextCollectionViewCell", bundle: nil)
        collectionView.register(textNib, forCellWithReuseIdentifier: "UITextCollectionViewCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = model.items[indexPath.row]
        
        switch item {
        case .image(let image):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UIImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
            cell.image.image = image
            cell.deleteButton.isHidden = !editMode // Show delete button only in edit mode
            cell.deleteAction = { [weak self] in
                self?.deleteItem(at: indexPath) // Handle the delete action
            }
            return cell
            
        case .text(let text):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UITextCollectionViewCell", for: indexPath) as! TextCollectionViewCell
            cell.text.text = text
            cell.deleteButton.isHidden = !editMode // Show delete button only in edit mode
            cell.deleteAction = { [weak self] in
                self?.deleteItem(at: indexPath) // Handle the delete action
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = model.items[indexPath.item]
        
        switch item {
        case .image(let image):
            return image.size // Return the image size
            
        case .text(let text):
            let width = collectionView.frame.width - 20 // Adjust padding
            _ = text.height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 16))
            return CGSize(width: 1280, height:1280) // Add padding
        }
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
        let movedItem = model.items.remove(at: sourceIndexPath.item)
        model.items.insert(movedItem, at: destinationIndexPath.item)
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
    
    @objc func addTextOrImage(){
        let alertController = UIAlertController(title: "Add Item", message: "Choose an item to add", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Add Image", style: .default, handler: { _ in
            self.openImagePicker(sourceType: .photoLibrary)
        }))
        
        alertController.addAction(UIAlertAction(title: "Capture Image", style: .default, handler: { _ in
            self.openImagePicker(sourceType: .camera)
        }))
        
        alertController.addAction(UIAlertAction(title: "Add Text", style: .default, handler: { _ in
            self.addText()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func toggleEditMode() {
        editMode.toggle()
        collectionView.reloadData()
        
        // Update the edit button title
        navigationItem.leftBarButtonItem?.title = editMode ? "Done" : "Edit"
    }
    
    func deleteItem(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            // Remove the item from the data source
            self.model.items.remove(at: indexPath.item)
            
            // Delete the item from the collection view
            self.collectionView.deleteItems(at: [indexPath])
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Not Available", message: "This source type is not available on your device.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
        
    func addText(){
            let textAlert = UIAlertController(title: "Add Text", message: nil, preferredStyle: .alert)
            
            textAlert.addTextField { textField in
                textField.placeholder = "Enter Text here"
            }
            
            textAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
                if let text = textAlert.textFields?.first?.text, !text.isEmpty {
                    self.model.items.append(.text(text))
                    self.collectionView.reloadData()
                }
            }))
            textAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(textAlert, animated: true, completion: nil)
    }
        
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)
            if let editedImage = info[.editedImage] as? UIImage {
                self.model.items.append(.image(editedImage))
            } else if let originalImage = info[.originalImage] as? UIImage {
                self.model.items.append(.image(originalImage))
            }
            
            collectionView.reloadData()
    }
        
    
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
        
        
        
        
        
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
