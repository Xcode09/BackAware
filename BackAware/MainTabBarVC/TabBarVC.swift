//
//  TabBarVC.swift
//  BackAware
//
//  Created by Muhammad Ali on 11/04/2021.
//

import UIKit

class TabBarVC: UITabBarController {

    var timer:Timer?
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
        if let isTrue = UserDefaults.standard.value(forKey: "0") as? String,isTrue == "true"{
            let time = (UserDefaults.standard.value(forKey: "notify") as? Int ?? 60) * 60
            
            let userInfo = ["t":Double(time)]
            timer = Timer.scheduledTimer(timeInterval: Double(time), target: self, selector: #selector(sendPoorNotifications(timer:)), userInfo:userInfo, repeats: true)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimerNotify), name: notifyNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBar.unselectedItemTintColor = .white
        self.selectedIndex = 1
    }

    
    
    private func setupPlanVC()->UINavigationController{
        
        let nav = UINavigationController(rootViewController: PlanVC(collectionViewLayout: UICollectionViewFlowLayout()))
        let tabBar = UITabBarItem(title: "Plans", image: UIImage(named: "plan"), selectedImage: UIImage(named: "plan"))
        nav.tabBarItem.tag = 1
        nav.tabBarItem = tabBar
        return nav
    }
    
    private func setupTrainingVC()->UINavigationController{
        
        let nav = UINavigationController(rootViewController: TrainningVC(collectionViewLayout: UICollectionViewFlowLayout()))
        let tabBar = UITabBarItem(title: "Trainings", image: UIImage(named: "fitness")?.withRenderingMode(.alwaysTemplate), selectedImage: UIImage(named: "fitness")?.withRenderingMode(.alwaysTemplate))
        nav.tabBarItem.tag = 2
        nav.tabBarItem = tabBar
        return nav
    }
    
    private func setupModeVC()->UINavigationController{
        
        let nav = UINavigationController(rootViewController: ModeVC(nibName: "ModeVC", bundle: nil))
        let tabBar = UITabBarItem(title: "Mode", image: UIImage(named: "mode")?.withRenderingMode(.alwaysTemplate), selectedImage: UIImage(named: "mode")?.withRenderingMode(.alwaysTemplate))
        nav.tabBarItem.tag = 1
        nav.tabBarItem = tabBar
        return nav
    }
    
    private func setupAboutVC()->UINavigationController{
        
        let nav = UINavigationController(rootViewController: AboutVC(nibName: "AboutVC", bundle: nil))
        let tabBar = UITabBarItem(title: "About", image: UIImage(named: "info00")?.withRenderingMode(.alwaysTemplate), selectedImage: UIImage(named: "info00")?.withRenderingMode(.alwaysTemplate))
        nav.tabBarItem.tag = 4
        nav.tabBarItem = tabBar
        return nav
    }
    
    private func setupStatisticsVC()->UINavigationController{
        
        let nav = UINavigationController(rootViewController: StatisticsVC(nibName: "StatisticsVC", bundle: nil))
        let tabBar = UITabBarItem(title: "Statistics", image:UIImage(named: "stat"), selectedImage: UIImage(named: "stat"))
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
    
    
    @objc private func sendPoorNotifications(timer:Timer){
        let dic = timer.userInfo as! [String:Any]
        let duration = dic["t"] as? Double ?? 4
        FirebaseDataService.instance.getData(eventType: .value) { (sensorValue) in
            FirebaseDataService.instance.getCalibrationData(eventType: .value) { (tuple) in
                let rangeNumber = tuple.1...tuple.0
                if rangeNumber ~= sensorValue {
                    return
                }
                else if tuple.0 > sensorValue{
                    NotificationService.shared.sendNotification(title: "Poor Position", body: "You are in Poor Position", timeDuration: duration, repeats: false)
                }
                else if tuple.1 < sensorValue
                {
                    NotificationService.shared.sendNotification(title: "Poor Position", body: "You are in Poor Position", timeDuration: duration, repeats: false)
                }
            }
        }
    }
    
    
    @objc private func updateTimerNotify(){
        timer?.invalidate()
        if let isTrue = UserDefaults.standard.value(forKey: "0") as? String,isTrue == "true"{
            let time = (UserDefaults.standard.value(forKey: "notify") as? Int ?? 60) * 60
            let userInfo = ["t":Double(time)]
            timer = Timer.scheduledTimer(timeInterval: Double(time), target: self, selector: #selector(sendPoorNotifications(timer:)), userInfo:userInfo, repeats: true)
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
