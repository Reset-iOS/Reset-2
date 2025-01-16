//
//  CanvasViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 03/12/24.
//

import UIKit
import CHTCollectionViewWaterfallLayout
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

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
        collectionView.backgroundColor = .secondarySystemBackground
        
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
        case .image(let imageURL):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UIImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
            if let url = URL(string: imageURL) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.image.image = image
                        }
                    }
                }
            }
            cell.deleteButton.isHidden = !editMode
            cell.deleteAction = { [weak self] in
                self?.deleteItem(at: indexPath)
            }
            return cell
            
        case .text(let text):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UITextCollectionViewCell", for: indexPath) as! TextCollectionViewCell
            cell.text.text = text
            cell.deleteButton.isHidden = !editMode
            cell.deleteAction = { [weak self] in
                self?.deleteItem(at: indexPath)
            }
            return cell
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = model.items[indexPath.item]
        
        switch item {
        case .image(let imageURL):
            if let image = UIImage(contentsOfFile: imageURL) {
                return image.size
            }
            return CGSize(width: 100, height: 100)
        
        case .text(let text):
            let width = collectionView.frame.width - 20
            let height = text.height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 16))
            return CGSize(width: 1280, height: 1280)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupCollectionView()
        registerNibs()
        
        fetchCanvasItems()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
        model.loadItems()
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update data source array to reflect the move
        let movedItem = model.items.remove(at: sourceIndexPath.item)
        model.items.insert(movedItem, at: destinationIndexPath.item)
        model.saveItems()
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
    
    func fetchCanvasItems() {
            model.fetchCanvasItems { [weak self] result in
                switch result {
                case .success(let items):
                    print("Fetched \(items.count) items from Firebase")
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                case .failure(let error):
                    print("Failed to fetch items: \(error.localizedDescription)")
                }
            }
    }
    
    func deleteItem(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            // Remove the item from the data source
            self.model.items.remove(at: indexPath.item)
            
            self.model.saveItems()
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
        
//    func addText(){
//            let textAlert = UIAlertController(title: "Add Text", message: nil, preferredStyle: .alert)
//            
//            textAlert.addTextField { textField in
//                textField.placeholder = "Enter Text here"
//            }
//            
//            textAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
//                if let text = textAlert.textFields?.first?.text, !text.isEmpty {
//                    self.model.items.append(.text(text))
//                    self.model.saveItems()
//                    self.collectionView.reloadData()
//                }
//            }))
//            textAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            present(textAlert, animated: true, completion: nil)
//    }
        
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            saveImage(editedImage) // Save the edited image
        } else if let originalImage = info[.originalImage] as? UIImage {
            saveImage(originalImage) // Save the original image
        }
        
        collectionView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        // Get the URL for the app's Documents directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
//    func saveImage(_ image: UIImage) {
//        // Convert the image to Data (PNG format)
//        if let imageData = image.pngData() {
//            // Save the image data to a file and get the file path
//            let fileName = UUID().uuidString + ".png"
//            let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
//            
//            do {
//                try imageData.write(to: fileURL)
//                // Store the file path in the model instead of the image data itself
//                model.items.append(.image(fileURL.path))
//                model.saveItems() // Save items to UserDefaults or a file
//            } catch {
//                print("Failed to save image: \(error.localizedDescription)")
//            }
//        }
//    }
        
    
    
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


extension CanvasViewController {
    func addText() {
        let textAlert = UIAlertController(title: "Add Text", message: nil, preferredStyle: .alert)
        
        textAlert.addTextField { textField in
            textField.placeholder = "Enter Text here"
        }
        
        textAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            guard let text = textAlert.textFields?.first?.text, !text.isEmpty else { return }
            
            // Upload text to Firebase
            self?.model.saveText(text) { result in
                switch result {
                case .success:
                    print("Text saved successfully!")
                    self?.model.items.append(.text(text))
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                case .failure(let error):
                    print("Failed to save text: \(error.localizedDescription)")
                }
            }
        }))
        
        textAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(textAlert, animated: true, completion: nil)
    }
    
    func saveImage(_ image: UIImage) {
        // Upload image to Firebase
        model.uploadImage(image) { [weak self] result in
            switch result {
            case .success(let imageURL):
                print("Image uploaded successfully! URL: \(imageURL)")
                
                // Save metadata to Firestore
                self?.model.saveImageMetadata(imageURL) { result in
                    switch result {
                    case .success:
                        self?.model.items.append(.image(imageURL))
                        DispatchQueue.main.async {
                            self?.collectionView.reloadData()
                        }
                    case .failure(let error):
                        print("Failed to save image metadata: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Failed to upload image: \(error.localizedDescription)")
            }
        }
    }
}
