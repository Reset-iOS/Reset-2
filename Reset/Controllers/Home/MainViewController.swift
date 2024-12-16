import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    var currentUser: Contact?
    var model = Model()
    let sections = ["Profile","Progress", "Savings", "Canvas"]
    let items = [
        ["Item 1.1"], // Items in Section 1
        ["Item 2.1"], // Items in Section 2
        ["Item 3.1"], // Items in Section 3
        ["Item 4.1"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = UserManager.shared.getCurrentUser() {
            currentUser = user
        } else {
            print("Error: No current user found.")
            // Optionally, set a default user or handle the case gracefully
            currentUser = Contact(name: "Default User", phone: "000-0000", email: "default@example.com", profile: "Emily", age: 0, joinDate: "", soberDuration: "", soberSince: "", numOfResets: 0, longestStreak: 0, daysPerWeek: 0, averageSpend: 0)
        }
        
        model.loadItems()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        model.loadItems()
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
        collectionView.register(UINib(nibName: "HomeProfileCell", bundle: nil), forCellWithReuseIdentifier: "HomeProfileCell")
        collectionView.register(UINib(nibName: "ProgressViewCell", bundle: nil), forCellWithReuseIdentifier: "ProgressViewCell")
        collectionView.register(UINib(nibName: "SavingsViewCell", bundle: nil), forCellWithReuseIdentifier: "SavingsViewCell")
        collectionView.register(UINib(nibName: "CanvasViewCell", bundle: nil), forCellWithReuseIdentifier: "CanvasViewCell")
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CustomHeaderView")
        
        collectionView.showsVerticalScrollIndicator = false
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
            // Profile Section - HomeProfileCell
            guard let user = currentUser else {
                fatalError("Error: `currentUser` is nil when attempting to configure the cell.")
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeProfileCell", for: indexPath) as! HomeProfileCell
            cell.configureCell(with: user.profile)
            cell.greetingLabel.text = "Hello \(user.name)"
            return cell
        }
        
        if indexPath.section == 1 {
            // Progress Section - ProgressViewCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgressViewCell", for: indexPath) as! ProgressViewCell
            
            // Calculate daysSoberOngoing based on the current user's soberSince date
            if let soberSinceDate = currentUser?.soberSince.toDate() {
                let daysSoberOngoing = soberSinceDate.days(from: Date())
                
                // Calculate the number of days to next milestone (example: 30 days per milestone)
                let daysToNextMilestone = 30 - (daysSoberOngoing % 30)
                
                // Progress is the ratio of days sober ongoing to the milestone (e.g., 30-day milestones)
                let progress = CGFloat(daysSoberOngoing % 30) / 30.0
                
                // Pass dynamic data to the cell
                cell.configureCell(daysSoberOngoing: daysSoberOngoing, daysToNextMilestone: daysToNextMilestone, progress: progress)
            } else {
                cell.configureCell(daysSoberOngoing: 0, daysToNextMilestone: 30, progress: 0.0)  // Default in case of nil
            }
            
            return cell
        }
        
        if indexPath.section == 2 {
            // Savings Section - SavingsViewCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavingsViewCell", for: indexPath) as! SavingsViewCell
            
            // Calculate overall savings based on days sober ongoing and average spend per day
            if let soberSinceDate = currentUser?.soberSince.toDate() {
                let daysSoberOngoing = soberSinceDate.days(from: Date())
                let overallSavings = daysSoberOngoing * currentUser!.averageSpend
                
                // Calculate savings for the week (divide by 7, but ensure 0 if less than 7 days)
                let daysThisWeek = min(daysSoberOngoing, 7)
                let savingsThisWeek = (daysThisWeek * currentUser!.averageSpend) / 7
                
                // Pass dynamic data to the cell
                cell.configureCell(overallSavings: overallSavings, weekSavings: savingsThisWeek)
            } else {
                cell.configureCell(overallSavings: 0, weekSavings: 0)  // Default if soberSince is nil
            }
            
            return cell
        }
        
        else {
            // Canvas Section - CanvasViewCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CanvasViewCell", for: indexPath) as! CanvasViewCell
            
            // Check if there are exactly three images in the model
            let imageItems = model.items.filter { if case .image = $0 { return true } else { return false } }
            
            if imageItems.count == 3 {
                // If there are exactly three images, configure with images
                let imageURLs = imageItems.compactMap { $0.imageURL() }
                if imageURLs.count == 3 {
                    cell.configureCell(imageOneString: imageURLs[0].absoluteString, imageTwoString: imageURLs[1].absoluteString, imageThreeString: imageURLs[2].absoluteString)
                } else {
                    // Call configureCellWithoutImages if there aren't three valid images
                    cell.configureCellWithoutImages()
                }
            } else {
                // If there aren't exactly three items, configure without images
                cell.configureCellWithoutImages()
            }
            
            return cell
        }
    }

    
    // MARK: - Header Configuration
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            // For other sections, dequeue and configure the header
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CustomHeaderView", for: indexPath) as! CustomHeaderView
            header.configure(with: sections[indexPath.section])
            return header
        }
        return UICollectionReusableView()
    }

    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: collectionView.bounds.width, height: 100)
        }
        
        let width = (collectionView.bounds.width - 30)
        return CGSize(width: width, height: 256
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
                return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item selected at section \(indexPath.section), row \(indexPath.row)")  // Debugging print
        if indexPath.section == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Levels")
            let navController = UINavigationController(rootViewController: viewController)
            present(navController, animated: true, completion: nil)
        } else if indexPath.section == 2 {
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

extension String {
    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func days(from date: Date) -> Int {
        let calendar = Calendar.current
        let startDate = self < date ? self : date
        let endDate = self < date ? date : self
        
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day ?? 0
    }
}

