//
//  TrackTimeGraph.swift
//  BackAware
//
//  Created by Muhammad Ali on 14/04/2021.
//

import UIKit
import Charts
class TrackTimeGraph: UIViewController {

    @IBOutlet weak var lineChart:LineChartView!
    
    //var options = Opt
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Track your workout!"
        lineChart.chartDescription?.enabled = false
        lineChart.dragEnabled = true
        lineChart.setScaleEnabled(true)
        lineChart.pinchZoomEnabled = true
        let l = lineChart.legend
        l.form = .line
        l.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        l.textColor = .red
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        
        let xAxis = lineChart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelTextColor = .red
        xAxis.drawAxisLineEnabled = false
        
        let leftAxis = lineChart.leftAxis
        leftAxis.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        leftAxis.axisMaximum = 200
        leftAxis.axisMinimum = 0
        //leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        
       
        let rightAxis = lineChart.rightAxis
        //rightAxis.drawri
        rightAxis.labelTextColor = .clear
        rightAxis.axisMaximum = 900
        rightAxis.axisMinimum = -200
        rightAxis.granularityEnabled = false
        lineChart.animate(xAxisDuration: 2.5)
        
        FirebaseDataService.instance.getTracKTimeStatisticsData { [weak self](ta) in
            
            self?.setData(data: ta)
        }
    }

    
//    override func updateChartData() {
//        if self.shouldHideData {
//            chartView.data = nil
//            return
//        }
//
//        self.setDataCount(Int(sliderX.value + 1), range: UInt32(sliderY.value))
//    }
    
    func setData(data:[TrackModel]){
        var enteris = [ChartDataEntry]()
        for i in 0..<40{
            enteris.append(ChartDataEntry(x: Double(i+10), y: Double(i-10)))
        }
        let set1 = LineChartDataSet(entries: enteris, label: "Sensor Data")
        set1.mode = .horizontalBezier
        set1.drawCirclesEnabled = false
        set1.drawCircleHoleEnabled = false
        let data = LineChartData(dataSet: set1)
        
        lineChart.data = data
        
    }

    func setDataCount(_ count: Int, range: UInt32) {
        let yVals1 = (0..<count).map { (i) -> ChartDataEntry in
            let mult = range / 2
            let val = Double(arc4random_uniform(mult) + 50)
            return ChartDataEntry(x: 500, y: 500)
        }
        let yVals2 = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 450)
            return ChartDataEntry(x: Double(i), y: val)
        }
        let yVals3 = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 500)
            return ChartDataEntry(x: Double(200), y: 200)
        }

        let set1 = LineChartDataSet(entries: yVals1, label: "Sensor Data")
        set1.axisDependency = .left
        set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        set1.setCircleColor(.white)
        set1.lineWidth = 2
        set1.circleRadius = 3
        set1.fillAlpha = 65/255
        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = false
        
        let set2 = LineChartDataSet(entries: yVals2, label: "Upper Limit")
        set2.axisDependency = .right
        set2.setColor(.red)
        set2.setCircleColor(.systemPink)
        set2.lineWidth = 2
        set2.circleRadius = 3
        set2.fillAlpha = 65/255
        set2.fillColor = .red
        set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set2.drawCircleHoleEnabled = false

        let set3 = LineChartDataSet(entries: yVals3, label: "Lower Limit")
        set3.axisDependency = .right
        set3.setColor(.yellow)
        set3.setCircleColor(.white)
        set3.lineWidth = 2
        set3.circleRadius = 3
        set3.fillAlpha = 65/255
        set3.fillColor = UIColor.yellow.withAlphaComponent(200/255)
        set3.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set3.drawCircleHoleEnabled = false
        
        let data = LineChartData(dataSets: [set1,set2,set3])
        data.setValueTextColor(.white)
        data.setValueFont(.systemFont(ofSize: 9))
        
        lineChart.data = data
    }

}
