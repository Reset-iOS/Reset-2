//
//  ContactsTableViewCell.swift
//  Reset
//
//  Created by Prasanjit Panda on 30/11/24.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius=profileImage.frame.size.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with contact: Contact) {
        name.text = contact.name
        profileImage.image = UIImage(named: contact.profile)
    }
}
