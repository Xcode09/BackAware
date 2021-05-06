//
//  Constants.swift
//  BackAware
//
//  Created by Muhammad Ali on 11/04/2021.
//

import UIKit

let APP_DATE_FORMATE = "yyyy-MM-dd"
let notifyNotification = Notification.Name(rawValue: "notifyTimer")
let poorPositionCheckNotification = Notification.Name(rawValue: "poorPositionCheckNotification")

var currentUserId = ""

var upperLimit = 0
var lowerLimit = 0

struct FirebaseDbPaths{
    static var baseUrl = "cJJoxX6SfRfSgoylos5KeFHL0SO2"
    static let calibrate = "Calibrate"
    static let sensorData = "SensorData"
    static let statistics = "Statistics"
    static let trackingTime = "TrackingTime"
    static let trainingTest = "TrainingTest"
}

public struct AppColors {
    static let bgColor = UIColor(named: "BGColor", in: Bundle.main, compatibleWith: .current)
    static let tabBarColor = UIColor(named: "TabBarColor")
    static let navBarColor = UIColor.white
    static let tabBarTintColor = UIColor(named: "TabBarColor")
    static let connectStatus = UIColor(named: "connected")
    static let tabTintColor = UIColor.red
    
    static let settingPageColor = UIColor(named: "SettingPageColor")
    static let tableViewColor = UIColor(named: "TableViewColor")
    static let labelColor = UIColor(named: "LabelTitle")
}


struct InfoModel {
    let title:String
    let ImageView:UIImage
    let link:String
}
struct AboutUsModel {
    static let contactItems = [
        InfoModel(title: "Email", ImageView: UIImage.init(systemName: "envelope.fill")!,link:"backawarebelt@gmail.com"),
        InfoModel(title: "Facebook", ImageView: UIImage(named: "fab")?.withRenderingMode(.alwaysOriginal) ?? UIImage(),link: ""),
        InfoModel(title: "Instagram", ImageView: UIImage(named: "insta")?.withRenderingMode(.alwaysOriginal) ?? UIImage(),link: ""),
        InfoModel(title: "Visit our site", ImageView: UIImage.init(systemName: "link")!,link: "https://everardpilates.com/")
    ]
    
    static let rateAppItems = [
        InfoModel(title: "BackAware", ImageView: UIImage(named: "rate")?.withRenderingMode(.alwaysOriginal) ?? UIImage(),link: ""),
    ]
    static let developByItems = [
        InfoModel(title: "Devomech Solutions", ImageView: UIImage.init(systemName: "link")!,link: "https://devomech.com/"),
        InfoModel(title: "© Copyrights © 2021", ImageView: UIImage(),link: "")
    ]
}
