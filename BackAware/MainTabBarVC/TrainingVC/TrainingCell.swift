//
//  TrainingCell.swift
//  BackAware
//
//  Created by Muhammad Ali on 16/04/2021.
//

import UIKit

class TrainingCell: UICollectionViewCell {

    @IBOutlet weak private var title : UILabel!
    @IBOutlet weak private var descriptionTitle : UILabel!
    //@IBOutlet weak private var freePlan : UILabel!
    @IBOutlet weak private var bgImage : UIImageView!
    
    var data : Plan?{
        didSet{
            title.text = data?.name ?? "N/A"
            descriptionTitle.text = data?.shortDescription ?? "N/A"
            //freePlan.text = data?.freePlan ?? "N/A"
            //bgImage.image = data?.image ?? UIImage()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
