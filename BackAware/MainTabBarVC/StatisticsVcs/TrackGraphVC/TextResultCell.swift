//
//  TextResultCell.swift
//  BackAware
//
//  Created by Muhammad Ali on 06/05/2021.
//

import UIKit

class TextResultCell: UITableViewCell {

    @IBOutlet weak private var testName:UILabel!
    @IBOutlet weak private var goodPos:UILabel!
    @IBOutlet weak private var poorFlex:UILabel!
    @IBOutlet weak private var poorExt:UILabel!
    var data : TrackTimeModel?{
        didSet{
            guard let data = data else {return}
            testName.text = data.testName
            goodPos.text = data.good
            poorExt.text = data.poorExt
            poorFlex.text = data.poorFlex
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
