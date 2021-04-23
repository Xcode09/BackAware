//
//  TrainingDetailHeader.swift
//  BackAware
//
//  Created by Muhammad Ali on 23/04/2021.
//

import UIKit

class TrainingDetailHeader: UICollectionViewCell {

    @IBOutlet weak private var title : UILabel!
    var data : Plan?{
        didSet{
            title.text = data?.fullDescription ?? "N/A"
//            descriptionTitle.text = data?.shortDescription ?? "N/A"
//            longDescriptionTitle .text = data?.fullDescription ?? "N/A"
//            weeksTitle.text = data?.duration ?? "N/A"
            //bgImage.image = data?.
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
