import UIKit

class TestViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let canvasLabel = UILabel()
    private var progressContainerView: ProgressContainerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupViews()
    }
    
    private func setupViews() {
        // Setup ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isUserInteractionEnabled = true
        view.addSubview(scrollView)
        
        // Setup ContentView for ScrollView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Setup HeaderView
        let headerView = SummaryHeaderView()
        headerView.parentViewController = self
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        // Setup ProgressContainerView
        let trackerView = ProgressContainerView()
        self.progressContainerView = trackerView
        trackerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(trackerView)
        trackerView.isUserInteractionEnabled = true
        addTapGestureRecognizers(to: trackerView)
        
        // Setup Canvas Label
        canvasLabel.text = "Canvas"
        canvasLabel.font = .systemFont(ofSize: 32, weight: .bold)
        canvasLabel.textColor = .black
        canvasLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(canvasLabel)
        
        // Setup GalleryView
        let galleryView = GalleryView()
        galleryView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(galleryView)
        galleryView.isUserInteractionEnabled = true
        let galleryGesture = UITapGestureRecognizer(target: self, action: #selector(openCanvas))
        galleryView.addGestureRecognizer(galleryGesture)
        
        setupConstraints(headerView: headerView, trackerView: trackerView, galleryView: galleryView)
        galleryView.loadImages()
        
        // Fetch initial user data
        fetchUserData()
    }
    
    private func fetchUserData() {
        AuthService.shared.fetchUser { [weak self] user, error in
            if let error = error {
                print("Error fetching user: \(error)")
                return
            }
            
            if let user = user {
                DispatchQueue.main.async {
                    // Update both the days and calculate progress
                    self?.updateProgress(days: Int(user.soberStreak))
                    self?.progressContainerView?.milestoneLabel.text = "You are \(30 - Int(user.soberStreak)) days away from next milestone"
                }
            }
        }
    }
    
    private func updateProgress(days: Int) {
        // Assuming 30 days is one full circle - adjust this value as needed
        let totalDays = 30
        progressContainerView?.updateProgress(days, totalDays: totalDays)
    }
    
    
    private func addTapGestureRecognizers(to trackerView: UIView) {
        // First tap gesture recognizer
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        trackerView.addGestureRecognizer(singleTapGesture)
        
        // Second tap gesture recognizer
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        trackerView.addGestureRecognizer(doubleTapGesture)
        
        // Ensure single tap doesn't interfere with double tap
        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
    @objc private func openCanvas() {
        let storyboard = UIStoryboard(name: "Canvas", bundle: nil)
        let canvasVC = storyboard.instantiateViewController(withIdentifier: "CanvasViewController")
        present(UINavigationController(rootViewController: canvasVC), animated: true, completion: nil)
    }
    
    @objc private func handleSingleTap(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Milestone", bundle: nil)
        let milestoneVC = storyboard.instantiateViewController(withIdentifier: "MilestoneViewController")
        present(milestoneVC, animated: true, completion: nil)
    }
    
    @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        print("RESET")
        
        // Update sober streak to 0
        AuthService.shared.updateSoberStreak(to: 0) { [weak self] error in
            if let error = error {
                print("Error updating sober streak: \(error)")
                return
            }
            
            // Update sober since to current date
            AuthService.shared.updateSoberSince(to: Date()) { error in
                if let error = error {
                    print("Error updating sober since: \(error)")
                    return
                }
                
                // Fetch updated user data and update UI
                DispatchQueue.main.async {
                    self?.fetchUserData()
                }
            }
        }
    }

    private func setupConstraints(headerView: SummaryHeaderView, trackerView: ProgressContainerView, galleryView: GalleryView) {
        NSLayoutConstraint.activate([
            // Header constraints
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 120),
            
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView constraints
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            // ProgressContainerView constraints
            trackerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            trackerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            trackerView.widthAnchor.constraint(equalToConstant: 350),
            trackerView.heightAnchor.constraint(equalToConstant: 500),
            
            // Canvas Label constraints
            canvasLabel.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 40),
            canvasLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            // GalleryView constraints
            galleryView.topAnchor.constraint(equalTo: canvasLabel.bottomAnchor, constant: 12),
            galleryView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            galleryView.widthAnchor.constraint(equalToConstant: 350),
            galleryView.heightAnchor.constraint(equalToConstant: 300),
            galleryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

