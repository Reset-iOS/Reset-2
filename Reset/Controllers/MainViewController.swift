import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    
    let sections = ["Progress", "Savings", "Canvas"]
    let items = [
        ["Item 1.1"], // Items in Section 1
        ["Item 2.1"], // Items in Section 2
        ["Item 3.1"] // Items in Section 3
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        // Initialize UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        
        // Initialize UICollectionView
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        // Register Cell and Header
        collectionView.register(UINib(nibName: "ProgressViewCell", bundle: nil), forCellWithReuseIdentifier: "ProgressViewCell")
        collectionView.register(UINib(nibName: "SavingsViewCell", bundle: nil), forCellWithReuseIdentifier: "SavingsViewCell")
        collectionView.register(UINib(nibName: "CanvasViewCell", bundle: nil), forCellWithReuseIdentifier: "CanvasViewCell")
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CustomHeaderView")
        
        // Add Collection View to the View
        view.addSubview(collectionView)
    }
    
    // MARK: - UICollectionView DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
                    // Use ProgressCollectionViewCell for the first section
            // Use ProgressViewCell for the first section
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgressViewCell", for: indexPath) as! ProgressViewCell
            // Pass dynamic data to the cell
            cell.configureCell(daysSoberOngoing: 100, daysToNextMilestone: 20, progress: 0.75) // Example data
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavingsViewCell", for: indexPath) as! SavingsViewCell
            // Pass dynamic data to the cell
            cell.configureCell(overallSavings:3000,weekSavings: 2100) // Example data
            return cell
        }
        
        else {
            // Use CustomCollectionViewCell for other sections
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CanvasViewCell", for: indexPath) as! CanvasViewCell
            cell.configureCell(imageOneString: "Emily", imageTwoString: "Emily", imageThreeString: "Emily")
            return cell
        }
        
    }
    
    // MARK: - Header Configuration
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CustomHeaderView", for: indexPath) as! CustomHeaderView
            header.configure(with: sections[indexPath.section])
            return header
        }
        return UICollectionReusableView()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30)
        return CGSize(width: width, height: 256
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item selected at section \(indexPath.section), row \(indexPath.row)")  // Debugging print
        if indexPath.section == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Levels")
            let navController = UINavigationController(rootViewController: viewController)
            present(navController, animated: true, completion: nil)
        } else if indexPath.section == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Levels")
            let navController = UINavigationController(rootViewController: viewController)
            present(navController, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Canvas", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Canvas")
            let navController = UINavigationController(rootViewController: viewController)
            present(navController, animated: true, completion: nil)

        }
    }
}
