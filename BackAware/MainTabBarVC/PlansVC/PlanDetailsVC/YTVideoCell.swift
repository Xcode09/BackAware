//
//  YTVideoCell.swift
//  BackAware
//
//  Created by Muhammad Ali on 18/04/2021.
//

import UIKit
import Kingfisher
class YTVideoCell: UICollectionViewCell {

    @IBOutlet weak private var title : UILabel!
   
    @IBOutlet weak private var bgImage : UIImageView!
    
    var data : Step?{
        didSet{
            title.text = data?.stepDescription ?? "N/A"
            if let id = data?.video?.replacingOccurrences(of: "https://youtu.be/", with: ""){
                DispatchQueue.main.async {
                    [weak self] in
                    self?.bgImage.kf.setImage(with: URL(string: "https://img.youtube.com/vi/\(id)/default.jpg"))
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
