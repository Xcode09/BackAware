//
//  TabBarVC.swift
//  BackAware
//
//  Created by Muhammad Ali on 11/04/2021.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.viewControllers = [setupModeVC(),setupPlanVC(),setupAboutVC()]
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedIndex = 1
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    private func setupPlanVC()->UINavigationController{
        
        let nav = UINavigationController(rootViewController: PlanVC(collectionViewLayout: UICollectionViewFlowLayout()))
        let tabBar = UITabBarItem(title: "Mode", image: UIImage.init(systemName: "house.fill"), selectedImage: UIImage.init(systemName: "house.fill"))
        nav.tabBarItem.tag = 2
        nav.tabBarItem = tabBar
        return nav
    }
    
    private func setupModeVC()->UINavigationController{
        
        let nav = UINavigationController(rootViewController: ModeVC(nibName: "ModeVC", bundle: nil))
        let tabBar = UITabBarItem(title: "Mode", image: UIImage.init(systemName: "house.fill"), selectedImage: UIImage.init(systemName: "house.fill"))
        nav.tabBarItem.tag = 1
        nav.tabBarItem = tabBar
        return nav
    }
    
    private func setupAboutVC()->UINavigationController{
        
        let nav = UINavigationController(rootViewController: AboutVC(nibName: "AboutVC", bundle: nil))
        let tabBar = UITabBarItem(title: "Mode", image: UIImage.init(systemName: "house.fill"), selectedImage: UIImage.init(systemName: "house.fill"))
        nav.tabBarItem.tag = 3
        nav.tabBarItem = tabBar
        return nav
    }
    
}
