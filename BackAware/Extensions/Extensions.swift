//
//  Extensions.swift
//  BackAware
//
//  Created by Muhammad Ali on 13/04/2021.
//

import UIKit
import AVKit
class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "checkbox")!
    let uncheckedImage = UIImage(named: "uncheckbox")!
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    
    var isTapped:((Bool)->Void)?
    
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if let isTrue = UserDefaults.standard.value(forKey: "\(self.tag)") as? String,isTrue == "true"{
            self.setImage(checkedImage, for: .normal)
            self.isChecked = true
        }else{
            self.isChecked = false
        }
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
            UserDefaults.standard.set("\(isChecked)", forKey: "\(self.tag)")
            UserDefaults.standard.synchronize()
            isTapped?(isChecked)
        }
    }
}


struct TimeAndDateHelper {
    static func getDate(date:Date=Date())->String{
        let currentDateTime = date
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.dateFormat = APP_DATE_FORMATE
        // get the date time String from the date object
        return formatter.string(from: currentDateTime)
    }
}

extension UIView{
    func applyCardView(cornerRadius:CGFloat=10.0){
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 12.0
        layer.shadowOpacity = 0.7
    }
}

extension UICollectionViewCell{
    func genarateThumbnailFromYouTubeID(youTubeID: String)->UIImage?
    {
        let urlString = "http://img.youtube.com/vi/\(youTubeID)/1.jpg"
        let image = UIImage(contentsOfFile: urlString)
        return image
    }
    
    
    //From VideoUrl
    func getThumbnailFromVideoUrl(urlString: String)->UIImage{
        let asset = AVAsset(url: URL(string: urlString)!)
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMake(value: 1, timescale: 20)
        let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
        if img != nil {
            let frameImg  = UIImage(cgImage: img!)
            return frameImg
        }
        return UIImage()
    }
}

extension String{
    func getAttributedString(alignment:NSTextAlignment = .left ,color:UIColor = .white)->NSAttributedString{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.firstLineHeadIndent = 5.0

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]

        let attributedQuote = NSAttributedString(string: self, attributes: attributes)
        return attributedQuote
    }
}
