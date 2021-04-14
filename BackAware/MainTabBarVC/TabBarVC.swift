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
        
        
        self.viewControllers = [setupModeVC(),setupPlanVC(),
                                setupStatisticsVC(),
                                setupAboutVC()]
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedIndex = 1
    }

    
    
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
        nav.tabBarItem.tag = 4
        nav.tabBarItem = tabBar
        return nav
    }
    
    private func setupStatisticsVC()->UINavigationController{
        
        let nav = UINavigationController(rootViewController: StatisticsVC(nibName: "StatisticsVC", bundle: nil))
        let tabBar = UITabBarItem(title: "Statistics", image: UIImage.init(systemName: "house.fill"), selectedImage: UIImage.init(systemName: "house.fill"))
        nav.tabBarItem.tag = 3
        nav.tabBarItem = tabBar
        return nav
    }
    
}
