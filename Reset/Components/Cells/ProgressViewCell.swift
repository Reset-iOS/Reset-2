//
//  ProgressViewCell.swift
//  Reset
//
//  Created by Prasanjit Panda on 15/12/24.
//

import UIKit

class ProgressViewCell: UICollectionViewCell {

    @IBOutlet weak var daysSoberOngoing: UILabel!
    
    @IBOutlet weak var medal: UIImageView!
    
    @IBOutlet weak var progressCardView: UIView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var daysToNextMilestone: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        progressCardView.layer.cornerRadius = 20
        progressCardView.layer.masksToBounds = false
        
        // Add shadow to the card view
        progressCardView.layer.shadowColor = UIColor.black.cgColor
        progressCardView.layer.shadowOpacity = 0.25
        progressCardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        // Vertical offset
        progressCardView.layer.shadowRadius = 6 // Blur radius
        progressCardView.layer.shadowPath = UIBezierPath(roundedRect: progressCardView.bounds, cornerRadius: progressCardView.layer.cornerRadius).cgPath
        
        // Optional: to improve performance by not recalculating the shadow every time the cell's bounds change
        progressCardView.layer.shouldRasterize = true
        progressCardView.layer.rasterizationScale = UIScreen.main.scale
        
        progressView.progressTintColor = .black
        daysSoberOngoing.textColor = .black
        daysToNextMilestone.textColor = .black
        
    }
    
    
    func configureCell(daysSoberOngoing: Int, daysToNextMilestone: Int, progress: Double) {
        self.daysSoberOngoing.text = "\(daysSoberOngoing)"
        self.daysToNextMilestone.text = "\(daysToNextMilestone) days to next milestone"
        progressView.progress = Float(progress)
        medal.image = UIImage(systemName: "medal.fill")
        medal.tintColor = .black
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        
    }
    
}
