//
//  TextCollectionViewCell.swift
//  Reset
//
//  Created by Prasanjit Panda on 13/12/24.
//

import UIKit

class TextCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var text: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var view: UIView!
    
    var deleteAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = false
        
        // Shadow properties
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 4
        
    }
    
    @IBAction func deleteItem(_ sender: Any) {
        deleteAction?()
    }
    
}
