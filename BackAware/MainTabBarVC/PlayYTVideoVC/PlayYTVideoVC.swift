//
//  PlayYTVideoVC.swift
//  BackAware
//
//  Created by Muhammad Ali on 18/04/2021.
//

import UIKit
import WebKit
class PlayYTVideoVC: UIViewController {

    @IBOutlet weak var webView : WKWebView!
    var videoUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadYoutube(videoID: videoUrl.replacingOccurrences(of: "https://youtu.be/", with: ""))
    }

    func loadYoutube(videoID:String) {
    guard let youtubeURL = URL(string:"https://www.youtube.com/embed/\(videoID)") else {
    return
    }
    webView.load(URLRequest(url: youtubeURL))
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}
