//
//  AboutVC.swift
//  BackAware
//
//  Created by Muhammad Ali on 11/04/2021.
//

import UIKit

class AboutVC: UITableViewController {
        
    private let identifer = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "About"
        self.view.backgroundColor = AppColors.bgColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifer)
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return AboutUsModel.contactItems.count
        case 1:
            return AboutUsModel.rateAppItems.count
        case 2:
            return AboutUsModel.developByItems.count
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: identifer, for: indexPath)

            cell.textLabel?.text = AboutUsModel.contactItems[indexPath.row].title
            cell.imageView?.tintColor = .white
            cell.imageView?.image = AboutUsModel.contactItems[indexPath.row].ImageView
            cell.backgroundColor = AppColors.bgColor
            cell.contentView.backgroundColor = AppColors.bgColor
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: identifer, for: indexPath)
            cell.textLabel?.text = AboutUsModel.rateAppItems[indexPath.row].title
            cell.imageView?.image = AboutUsModel.rateAppItems[indexPath.row].ImageView
            cell.backgroundColor = AppColors.bgColor
            cell.contentView.backgroundColor = AppColors.bgColor
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: identifer, for: indexPath)
            cell.backgroundColor = AppColors.bgColor
            cell.contentView.backgroundColor = AppColors.bgColor
            cell.textLabel?.text = AboutUsModel.developByItems[indexPath.row].title
            cell.imageView?.tintColor = .white
            cell.imageView?.image = AboutUsModel.developByItems[indexPath.row].ImageView
            if indexPath.row == 1{
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.text = AboutUsModel.developByItems[indexPath.row].title
                cell.imageView?.tintColor = .white
                cell.imageView?.image = AboutUsModel.developByItems[indexPath.row].ImageView
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: identifer, for: indexPath)
            cell.backgroundColor = AppColors.bgColor
            cell.contentView.backgroundColor = AppColors.bgColor
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                // Email
                guard let url = URL(string:AboutUsModel.contactItems[indexPath.row].link) else { return }
                UIApplication.shared.open(url)
            }else{
                guard let url = URL(string:AboutUsModel.contactItems[indexPath.row].link) else { return }
                UIApplication.shared.open(url)
            }
        case 1:
            guard let url = URL(string:AboutUsModel.rateAppItems[indexPath.row].link) else { return }
            UIApplication.shared.open(url)
        case 2:
            guard let url = URL(string:AboutUsModel.rateAppItems[indexPath.row].link) else { return }
            UIApplication.shared.open(url)
        case 3:
            guard let url = URL(string:AboutUsModel.developByItems[indexPath.row].link) else { return }
            UIApplication.shared.open(url)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    fileprivate func customHeaderView(_ tableView: UITableView,title:String="") -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = title
        label.font = .systemFont(ofSize: 16)
        label.textColor = AppColors.labelColor
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return customHeaderView(tableView,title: "Contact Us")
        case 1:
            return customHeaderView(tableView,title: "Rate Our App")
        case 2:
            return customHeaderView(tableView,title: "Develop By")
        default:
            return customHeaderView(tableView)
        }
        
        
        
    }
 
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
}
