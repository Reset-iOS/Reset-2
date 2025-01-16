//
//  UploadPostViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 06/01/25.
//

import UIKit
import Photos

class UploadPostViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var assets: [PHAsset] = [] // Store all photo and video assets
    private var selectedImage: UIImage? // Store the currently selected or captured image
    
    private let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black.withAlphaComponent(0.6)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        return collectionView
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(previewImageView)
        view.addSubview(cameraButton)
        view.addSubview(collectionView)
        view.addSubview(nextButton)
        
        cameraButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(goToNextViewController), for: .touchUpInside)
        
        setupUI()
        checkPhotoLibraryPermission()
    }
    
    func setupUI() {
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            previewImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            previewImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            cameraButton.bottomAnchor.constraint(equalTo: previewImageView.bottomAnchor, constant: -10),
            cameraButton.trailingAnchor.constraint(equalTo: previewImageView.trailingAnchor, constant: -10),
            cameraButton.widthAnchor.constraint(equalToConstant: 40),
            cameraButton.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: previewImageView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -10),
            
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Camera
    @objc private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let alert = UIAlertController(title: "Camera Not Available", message: "This device does not support a camera.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage {
            previewImageView.image = image
            selectedImage = image
        } else if let image = info[.originalImage] as? UIImage {
            previewImageView.image = image
            selectedImage = image
        }
    }
    
    // MARK: - Next Button
    @objc private func goToNextViewController() {
        print("Clicked")
        guard let selectedImage = selectedImage else {
            let alert = UIAlertController(title: "No Image Selected", message: "Please select or capture an image before proceeding.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let postViewController = PostViewController()
        postViewController.uploadPostViewController = self
        postViewController.imageToPost = selectedImage
        present(postViewController, animated: true)
    }

    
    // MARK: - Photo Library Access
    private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    if status == .authorized || status == .limited {
                        self?.fetchPhotos()
                    } else {
                        self?.showAccessDeniedAlert()
                    }
                }
            }
        case .authorized, .limited:
            fetchPhotos()
        case .denied, .restricted:
            showAccessDeniedAlert()
        @unknown default:
            break
        }
    }
    
    private func showAccessDeniedAlert() {
        let alert = UIAlertController(
            title: "Access Denied",
            message: "Please enable photo library access in Settings to display your photos.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

    // MARK: - Fetch Photos
    private func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)] // Show recent first
        
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        fetchResult.enumerateObjects { [weak self] asset, _, _ in
            self?.assets.append(asset)
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            
            if let firstAsset = self.assets.first {
                self.displayPreview(for: firstAsset)
                self.updateSelectedImage(for: firstAsset) // Update selectedImage with the first image
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        let asset = assets[indexPath.item]
        let imageManager = PHImageManager.default()
        let targetSize = CGSize(width: 150, height: 150) // Thumbnail size
        
        imageManager.requestImage(for: asset,
                                  targetSize: targetSize,
                                  contentMode: .aspectFill,
                                  options: nil) { image, _ in
            cell.configure(with: image)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 4
        let padding: CGFloat = 2 * (itemsPerRow - 1)
        let totalWidth = collectionView.frame.width - padding
        let itemWidth = totalWidth / itemsPerRow
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = assets[indexPath.item]
        displayPreview(for: asset)
        
        // Update the selectedImage with the selected asset
        let imageManager = PHImageManager.default()
        let targetSize = CGSize(width: view.frame.width, height: view.frame.width)
        
        imageManager.requestImage(for: asset,
                                  targetSize: targetSize,
                                  contentMode: .aspectFit,
                                  options: nil) { [weak self] image, _ in
            self?.previewImageView.image = image
            self?.selectedImage = image // Make sure selectedImage is updated
        }
    }
    
    // MARK: - Display Preview
    private func displayPreview(for asset: PHAsset) {
        let imageManager = PHImageManager.default()
        let targetSize = CGSize(width: view.frame.width, height: view.frame.width)
        
        imageManager.requestImage(for: asset,
                                  targetSize: targetSize,
                                  contentMode: .aspectFit,
                                  options: nil) { [weak self] image, _ in
            self?.previewImageView.image = image
        }
    }
    
    private func updateSelectedImage(for asset: PHAsset) {
        let imageManager = PHImageManager.default()
        let targetSize = CGSize(width: view.frame.width, height: view.frame.width)
        
        imageManager.requestImage(for: asset,
                                  targetSize: targetSize,
                                  contentMode: .aspectFit,
                                  options: nil) { [weak self] image, _ in
            self?.previewImageView.image = image
            self?.selectedImage = image // Set the selectedImage
        }
    }
}

// MARK: - PhotoCell
class PhotoCell: UICollectionViewCell {
    static let identifier = "PhotoCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage?) {
        imageView.image = image
    }
}


