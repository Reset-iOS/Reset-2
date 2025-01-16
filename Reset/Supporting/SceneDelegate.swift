//
//  SceneDelegate.swift
//  Reset
//
//  Created by Prasanjit Panda on 03/01/25.
//

import UIKit
import Firebase
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            self.setupWindow(with: scene)
//        let storyboard = UIStoryboard(name: "Milestone", bundle: nil)
//        let initialViewController = storyboard.instantiateViewController(withIdentifier: "MilestoneViewController")
//        window?.rootViewController = UINavigationController(rootViewController: initialViewController)
//        goToController(with: UploadPostViewController())
            self.checkAuthentication()
        }
        
    
        private func setupWindow(with scene: UIScene) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            self.window?.makeKeyAndVisible()
        }
        
        public func checkAuthentication() {
            if Auth.auth().currentUser == nil {
                print("User no auth")
                self.goToController(with: OnboardingParentViewController())
            } else {
                let vc = createTabBarController()
                self.goToControllerTab(with: vc)
            }
        }
        
        private func goToController(with viewController: UIViewController) {
            print(viewController)
            DispatchQueue.main.async { [weak self] in
                UIView.animate(withDuration: 0.25) {
                    self?.window?.layer.opacity = 0
                    
                } completion: { [weak self] _ in
                    
                    let nav = UINavigationController(rootViewController: viewController)
                    nav.modalPresentationStyle = .fullScreen
                    self?.window?.rootViewController = nav
                    
                    UIView.animate(withDuration: 0.25) { [weak self] in
                        self?.window?.layer.opacity = 1
                    }
                }
            }
        }
    
    private func goToControllerTab(with viewController: UIViewController) {
        print(viewController)
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.25) {
                self?.window?.layer.opacity = 0
                
            } completion: { [weak self] _ in
                
                let vc = viewController
                self?.window?.rootViewController = vc
                
                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.window?.layer.opacity = 1
                }
            }
        }
    }
    
    func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        // TestViewController
        let testVC = TestViewController()
        testVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)

        // SupportViewController
        let storyboard = UIStoryboard(name: "Support", bundle: nil)
        let supportVC = storyboard.instantiateViewController(withIdentifier: "SupportViewController")
        supportVC.tabBarItem = UITabBarItem(title: "Support", image: UIImage(systemName: "figure.2"), tag: 1)

        // CommunityViewController
        let communityVC = CommunityViewController()
        communityVC.tabBarItem = UITabBarItem(title: "Community", image: UIImage(systemName: "person.3.fill"), tag: 2)

        // Add view controllers to TabBarController
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: testVC),
            UINavigationController(rootViewController: supportVC),
            UINavigationController(rootViewController: communityVC)
        ]

        // Customize the appearance of the TabBar
        if let tabBar = tabBarController.tabBar as? UITabBar {
            tabBar.tintColor = UIColor.systemBrown        // Color for selected items
            tabBar.unselectedItemTintColor = UIColor.gray   // Color for unselected items
            tabBar.backgroundColor = UIColor.systemGroupedBackground // Optional: Background color
        }

        // Additional customization for specific items
        if let items = tabBarController.tabBar.items {
            items[0].setTitleTextAttributes([.foregroundColor: UIColor.systemBrown], for: .selected) // Home item selected
            items[1].setTitleTextAttributes([.foregroundColor: UIColor.systemBrown], for: .selected) // Support item selected
            items[2].setTitleTextAttributes([.foregroundColor: UIColor.systemBrown], for: .selected) // Community item selected
        }

        return tabBarController
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

