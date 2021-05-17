//
//  Constants.swift
//  BackAware
//
//  Created by Muhammad Ali on 11/04/2021.
//

import UIKit
import Charts
let APP_DATE_FORMATE = "yyyy-MM-dd"
let notifyNotification = Notification.Name(rawValue: "notifyTimer")
let poorPositionCheckNotification = Notification.Name(rawValue: "poorPositionCheckNotification")

var currentUserId = ""

var upperLimit = 0
var lowerLimit = 0

fileprivate let componets = Calendar.current.dateComponents([.year], from: Date())
fileprivate let currentYear = "\(componets.year ?? 0)"

struct FirebaseDbPaths{
    static var baseUrl = "cJJoxX6SfRfSgoylos5KeFHL0SO2"
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
    static let connectStatus = UIColor(named: "connected")
    static let tabTintColor = UIColor.red
    
    static let settingPageColor = UIColor(named: "SettingPageColor")
    static let tableViewColor = UIColor(named: "TableViewColor")
    static let labelColor = UIColor(named: "LabelTitle")
    
    static let green = NSUIColor(cgColor: UIColor(red: 0, green: 255, blue: 0, alpha: 1).cgColor)
        
    static let red = NSUIColor(cgColor: UIColor(red: 254, green: 0, blue: 0, alpha: 1).cgColor)
        
    static let black = NSUIColor(cgColor: UIColor.black.cgColor)
    //static let lightTextColor = nil
    static let chartColors : [NSUIColor] = [green,red,black]
    
    static let lightTextColor = #colorLiteral(red: 0.4509803922, green: 0.4509803922, blue: 0.4509803922, alpha: 1)
}


struct InfoModel {
    let title:String
    let ImageView:UIImage
    let link:String
}
struct AboutUsModel {
    
    static let contactItems = [
        InfoModel(title: "Email", ImageView: UIImage.init(systemName: "envelope.fill")!,link:"googlegmail:///co?subject=Subject&body=some text&to=devomechsolutions06@gmail.com"
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!),
        InfoModel(title: "Facebook", ImageView: UIImage(named: "fab")?.withRenderingMode(.alwaysOriginal) ?? UIImage(),link: ""),
        InfoModel(title: "Instagram", ImageView: UIImage(named: "insta")?.withRenderingMode(.alwaysOriginal) ?? UIImage(),link: ""),
        InfoModel(title: "Visit our site", ImageView: UIImage.init(systemName: "link")!,link: "https://everardpilates.com/")
    ]
    
    static let rateAppItems = [
        InfoModel(title: "BackAware", ImageView: UIImage(named: "rate")?.withRenderingMode(.alwaysOriginal) ?? UIImage(),link: ""),
    ]
    static let developByItems = [
        InfoModel(title: "Devomech Solutions", ImageView: UIImage.init(systemName: "link")!,link: "https://devomech.com/"),
        InfoModel(title: "© Copyrights © \(currentYear)", ImageView: UIImage(),link: "")
    ]
}
