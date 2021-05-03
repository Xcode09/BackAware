//
//  StatisticsVC.swift
//  BackAware
//
//  Created by Muhammad Ali on 14/04/2021.
//

import UIKit
import Charts
class StatisticsVC: UIViewController {

    @IBOutlet private weak var pieChart:PieChartView!
    
    @IBOutlet private weak var trackTime:UIImageView!{
        didSet{
            trackTime.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToTrackTime)))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        pieChart.delegate = self
        
        var enteries = [ChartDataEntry]()
        
        FirebaseDataService.instance.getPieStatisticsData { [weak self](dataArr) in
            _ = dataArr.map({enteries.append(ChartDataEntry(x: Double($0), y: Double($0)))})
            
            let set = PieChartDataSet(entries: enteries)
            let green = UIColor(red: 0, green: 255, blue: 0, alpha: 1).cgColor
            let red = UIColor(red: 254, green: 0, blue: 0, alpha: 1).cgColor
            let black = UIColor.black.cgColor
            set.colors = [NSUIColor(cgColor: green),NSUIColor(cgColor: red),NSUIColor(cgColor: black)]
            let data = PieChartData(dataSet: set)
            self?.pieChart.data = data
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Statistics"
    }
    
    @objc private func goToTrackTime(){
        let vc = TrackTimeGraph(nibName: "TrackTimeGraph", bundle: nil)
        navigationItem.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension StatisticsVC:ChartViewDelegate{}
