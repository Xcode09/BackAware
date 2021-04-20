//
//  PlanCell.swift
//  BackAware
//
//  Created by Muhammad Ali on 11/04/2021.
//

import UIKit

class PlanCell: UICollectionViewCell {

    @IBOutlet weak private var title : UILabel!
    @IBOutlet weak private var descriptionTitle : UILabel!
    @IBOutlet weak private var freePlan : UILabel!
    @IBOutlet weak private var bgImage : UIImageView!
    
    var data : Plan?{
        didSet{
            title.text = data?.name ?? "N/A"
            descriptionTitle.text = data?.shortDescription ?? "N/A"
            freePlan.text = data?.isFree == true ? "Free Plan" : "Paid Plan"
            //bgImage.image = data?.
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
