//
//  HomeViewController.swift
//  Reset
//
//  Created by Raksha on 02/12/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var dayDate: UILabel!
    @IBOutlet weak var summaryCard: UIView!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var milestoneLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var medalIcon: UIImageView!
    @IBOutlet weak var resetButton: UIImageView!
    
    @IBOutlet weak var overallSavingsAmt: UILabel!
    
    @IBOutlet weak var savingsThisWeekAmt: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Summary"
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
