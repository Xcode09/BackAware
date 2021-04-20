//
//  Constants.swift
//  BackAware
//
//  Created by Muhammad Ali on 11/04/2021.
//

import UIKit

let APP_DATE_FORMATE = "yyyy-MM-dd"
struct FirebaseDbPaths{
    static let baseUrl = "cJJoxX6SfRfSgoylos5KeFHL0SO2"
    static let calibrate = "Calibrate"
    static let sensorData = "SensorData"
    static let statistics = "Statistics"
    static let trackingTime = "TrackingTime"
    static let trainingTest = "TrainingTest"
}

struct AppColors {
    static let bgColor = UIColor(named: "BGColor", in: Bundle.main, compatibleWith: .current)
    static let tabBarColor = UIColor(named: "TabBarColor")
    static let navBarColor = UIColor.white
    static let tabBarTintColor = UIColor(named: "TabBarColor")
    static let tabTintColor = UIColor.red
    
    static let settingPageColor = UIColor(named: "SettingPageColor")
    static let tableViewColor = UIColor(named: "TableViewColor")
    static let labelColor = UIColor(named: "LabelTitle")
}


struct InfoModel {
    let title:String
    let ImageView:UIImage
}
struct AboutUsModel {
    static let contactItems = [
        InfoModel(title: "Email", ImageView: UIImage.init(systemName: "envelope.fill")!),
        InfoModel(title: "Facebook", ImageView: UIImage()),
        InfoModel(title: "Instagram", ImageView: UIImage()),
        InfoModel(title: "Visit our site", ImageView: UIImage.init(systemName: "link")!)
    ]
    
    static let rateAppItems = [
        InfoModel(title: "BackAware", ImageView: UIImage()),
    ]
    static let developByItems = [
        InfoModel(title: "Devomech Solutions", ImageView: UIImage.init(systemName: "link")!),
    ]
}
