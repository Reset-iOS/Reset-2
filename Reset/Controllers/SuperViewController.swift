//
//  SuperViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 15/12/24.
//

import UIKit

class SuperViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Access the current user
        

        let home = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let support = UIStoryboard(name: "Support", bundle: nil).instantiateInitialViewController()!
        support.tabBarItem = UITabBarItem(title: "Support", image: UIImage(systemName: "figure.2"), tag: 1)
        
        let community = UIStoryboard(name: "Community", bundle: nil).instantiateInitialViewController()!
        community.tabBarItem = UITabBarItem(title: "Community", image: UIImage(systemName: "person.3.fill"), tag: 2)
        
        self.viewControllers = [home, support, community]
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
