//
//  Constants.swift
//  BackAware
//
//  Created by Muhammad Ali on 11/04/2021.
//

import UIKit


struct AppColors {
    static let bgColor = UIColor.systemBackground
    static let tabBarColor = UIColor(named: "TabBarColor")
    static let navBarColor = UIColor.white
    static let tabBarTintColor = UIColor(named: "TabBarColor")
    static let tabTintColor = UIColor.red
    
    static let labelColor = UIColor(named: "LabelTitle")
}


struct InfoModel {
    let title:String
    let ImageView:UIImage
}
struct AboutUsModel {
    static let contactItems = [
        InfoModel(title: "Email", ImageView: UIImage()),
        InfoModel(title: "Facebook", ImageView: UIImage()),
        InfoModel(title: "Instagram", ImageView: UIImage()),
        InfoModel(title: "Visit our site", ImageView: UIImage())
    ]
    
    static let rateAppItems = [
        InfoModel(title: "BackAware", ImageView: UIImage()),
    ]
    static let developByItems = [
        InfoModel(title: "Devomech Solutions", ImageView: UIImage()),
    ]
}