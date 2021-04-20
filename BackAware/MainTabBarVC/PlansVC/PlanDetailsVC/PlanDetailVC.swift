//
//  PlanDetailVC.swift
//  BackAware
//
//  Created by Muhammad Ali on 18/04/2021.
//

import UIKit

private let reuseIdentifier = "PlanDetailHeader"
private let reuseIdentifier1 = "YTVideoCell"

class PlanDetailVC: UICollectionViewController,UICollectionViewDelegateFlowLayout{

    var plan : Plan?
    
//    init() {
//        collectionView.
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = AppColors.bgColor
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView!.register(UINib(nibName: reuseIdentifier1, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier1)

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = plan?.name ?? "Plans"
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        switch section {
        case 0:
            return 1
        default:
            return plan?.steps?.count ?? 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PlanDetailHeader
            cell.data = plan
        
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier1, for: indexPath) as! YTVideoCell
            cell.data = plan?.steps?[indexPath.item]
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return .init(width: self.collectionView.frame.width - 10, height: 500)
        default:
            return .init(width: self.collectionView.frame.width - 10, height:70)
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1{
            let vc = PlayYTVideoVC(nibName: "PlayYTVideoVC", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            vc.videoUrl = plan?.steps?[indexPath.item].video ?? ""
            self.present(vc, animated: true, completion: nil)
        }
    }
}
