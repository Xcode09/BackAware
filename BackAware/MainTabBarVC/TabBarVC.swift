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
                                setupTrainingVC(),
                                setupStatisticsVC(),
                                setupAboutVC()]
        
        self.view.backgroundColor = AppColors.bgColor
        
        FirebaseDataService.instance.getData(eventType: .childChanged) { [weak self]  (sensorValue) in
            self?.getCalibrationData(sensorValue: sensorValue)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedIndex = 1
    }

    
    
    private func setupPlanVC()->UINavigationController{
        
        let nav = UINavigationController(rootViewController: PlanVC(collectionViewLayout: UICollectionViewFlowLayout()))
        let tabBar = UITabBarItem(title: "Plans", image: UIImage.init(systemName: "calendar"), selectedImage: UIImage.init(systemName: "calendar"))
        nav.tabBarItem.tag = 1
        nav.tabBarItem = tabBar
        return nav
    }
    
    private func setupTrainingVC()->UINavigationController{
        
        let nav = UINavigationController(rootViewController: TrainningVC(collectionViewLayout: UICollectionViewFlowLayout()))
        let tabBar = UITabBarItem(title: "Trainings", image: UIImage(named: "training"), selectedImage: UIImage(named: "training"))
        nav.tabBarItem.tag = 2
        nav.tabBarItem = tabBar
        return nav
    }
    
    private func setupModeVC()->UINavigationController{
        
        let nav = UINavigationController(rootViewController: ModeVC(nibName: "ModeVC", bundle: nil))
        let tabBar = UITabBarItem(title: "Mode", image: UIImage.init(systemName: "gearshape.fill"), selectedImage: UIImage.init(systemName: "gearshape.fill"))
        nav.tabBarItem.tag = 1
        nav.tabBarItem = tabBar
        return nav
    }
    
    private func setupAboutVC()->UINavigationController{
        
        let nav = UINavigationController(rootViewController: AboutVC(nibName: "AboutVC", bundle: nil))
        let tabBar = UITabBarItem(title: "About", image: UIImage.init(systemName: "info.circle.fill"), selectedImage: UIImage(named: "info.circle.fill"))
        nav.tabBarItem.tag = 4
        nav.tabBarItem = tabBar
        return nav
    }
    
    private func setupStatisticsVC()->UINavigationController{
        
        let nav = UINavigationController(rootViewController: StatisticsVC(nibName: "StatisticsVC", bundle: nil))
        let tabBar = UITabBarItem(title: "Statistics", image: UIImage.init(systemName: "chart.bar.fill"), selectedImage: UIImage.init(systemName: "chart.bar.fill"))
        nav.tabBarItem.tag = 3
        nav.tabBarItem = tabBar
        return nav
    }
    
    private func getCalibrationData(sensorValue:Int){
        FirebaseDataService.instance.getCalibrationData(eventType: .value) { (tuple) in
            let rangeNumber = tuple.1...tuple.0
            if rangeNumber ~= sensorValue {
                let para : [String:Any] = ["Time":TimeAndDateHelper.getDate(),"good":sensorValue,"poorExtension":0,"poorFlex":0]
                FirebaseDataService.instance.setData(path: FirebaseDbPaths.statistics, value: para)
            }
            else if tuple.0 > sensorValue{
                let para : [String:Any] = ["Time":TimeAndDateHelper.getDate(),"good":0,"poorExtension":0,"poorFlex":sensorValue]
                FirebaseDataService.instance.setData(path: FirebaseDbPaths.statistics, value: para)
                
            }
            else if tuple.1 < sensorValue
            {
                let para : [String:Any] = ["Time":TimeAndDateHelper.getDate(),"good":0,"poorExtension":sensorValue,"poorFlex":0]
                FirebaseDataService.instance.setData(path: FirebaseDbPaths.statistics, value: para)
            }
        }
    }
    
}
