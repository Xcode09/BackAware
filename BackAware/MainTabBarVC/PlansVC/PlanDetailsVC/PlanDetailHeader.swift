//
//  PlanDetailHeader.swift
//  BackAware
//
//  Created by Muhammad Ali on 18/04/2021.
//

import UIKit

class PlanDetailHeader: UICollectionViewCell {

    @IBOutlet weak private var title : UILabel!
    @IBOutlet weak private var descriptionTitle : UILabel!
    @IBOutlet weak private var longDescriptionTitle : UILabel!
    @IBOutlet weak private var weeksTitle : UILabel!
    @IBOutlet weak private var bgImage : UIImageView!
    var data : Plan?{
        didSet{
            title.text = data?.name ?? "N/A"
            descriptionTitle.text = data?.shortDescription ?? "N/A"
            longDescriptionTitle .text = data?.fullDescription ?? "N/A"
            weeksTitle.text = data?.duration ?? "N/A"
            //bgImage.image = data?.
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
