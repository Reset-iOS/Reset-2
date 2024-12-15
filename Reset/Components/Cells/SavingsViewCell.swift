//
//  SavingsViewCell.swift
//  Reset
//
//  Created by Prasanjit Panda on 15/12/24.
//

import UIKit

class SavingsViewCell: UICollectionViewCell {

    @IBOutlet weak var savingsCardView: UIView!
    @IBOutlet weak var savingsThisWeekValueLabel: UILabel!
    @IBOutlet weak var savingsThisWeekLabel: UIStackView!
    @IBOutlet weak var overallSavingsValueLabel: UILabel!
    @IBOutlet weak var overallSavingsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        savingsCardView.layer.cornerRadius=20
        savingsCardView.layer.masksToBounds=true
    }
    func configureCell(overallSavings:Int, weekSavings:Int) {
        savingsThisWeekValueLabel.text = "\(weekSavings)"
        overallSavingsValueLabel.text = "\(overallSavings)"
    }

}
