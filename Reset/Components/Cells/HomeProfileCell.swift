//
//  HomeProfileCell.swift
//  Reset
//
//  Created by Prasanjit Panda on 16/12/24.
//

import UIKit

class HomeProfileCell: UICollectionViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.masksToBounds = true

        greetingLabel.text = "Hello, user!"
        // Format the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMMM"  // Day of the week, Day, Month
        let formattedDate = dateFormatter.string(from: Date())
        
        dateLabel.text = formattedDate
        
    }
    
    func configureCell(with image: String) {
        profileImage.image = UIImage(named: image)
    }
    

}
