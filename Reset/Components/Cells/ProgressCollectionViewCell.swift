import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let daysToMilestoneLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private let progressView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let progressBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    private let awardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .orange
        return imageView
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "refresh"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(red: 0.4, green: 0.5, blue: 0.8, alpha: 1.0)
        
        contentView.addSubview(daysLabel)
        contentView.addSubview(daysToMilestoneLabel)
        contentView.addSubview(progressView)
        contentView.addSubview(awardImageView)
        contentView.addSubview(refreshButton)
        
        progressView.addSubview(progressBarView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        daysToMilestoneLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressBarView.translatesAutoresizingMaskIntoConstraints = false
        awardImageView.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            daysLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            daysToMilestoneLabel.topAnchor.constraint(equalTo: daysLabel.bottomAnchor, constant: 8),
            daysToMilestoneLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            progressView.topAnchor.constraint(equalTo: daysToMilestoneLabel.bottomAnchor, constant: 16),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            progressView.heightAnchor.constraint(equalToConstant: 24),
            
            progressBarView.topAnchor.constraint(equalTo: progressView.topAnchor),
            progressBarView.leadingAnchor.constraint(equalTo: progressView.leadingAnchor),
            progressBarView.heightAnchor.constraint(equalTo: progressView.heightAnchor),
            progressBarView.widthAnchor.constraint(equalToConstant: 0), // Set this programmatically based on progress
            
            awardImageView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 16),
            awardImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            awardImageView.widthAnchor.constraint(equalToConstant: 24),
            awardImageView.heightAnchor.constraint(equalToConstant: 24),
            
            refreshButton.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 16),
            refreshButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            refreshButton.widthAnchor.constraint(equalToConstant: 24),
            refreshButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with days: Int, progress: Double) {
        daysLabel.text = "\(days)"
        daysToMilestoneLabel.text = "\(18 - days) days to milestone"
        
        let progressWidth = contentView.bounds.width - 32
        progressBarView.widthAnchor.constraint(equalToConstant: progressWidth * CGFloat(progress)).isActive = true
    }
}
