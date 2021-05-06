//
//  TrackTimeGraph.swift
//  BackAware
//
//  Created by Muhammad Ali on 14/04/2021.
//

import UIKit
import Charts
class TrackTimeGraph: UIViewController,UITextFieldDelegate{

    @IBOutlet weak private var lineChart:LineChartView!
    
    //var options = Opt
    private var sensorValues = [Int]()
    private var testResults = [TrackTimeModel]()
    private var timer : Timer?
    private let cellString = "TextResultCell"
    @IBOutlet weak private var testName:UITextField!{
        didSet{
            testName.delegate = self
            testName.returnKeyType = .go
        }
    }
    
    @IBOutlet weak private var tableView:UITableView!{
        didSet{
            
            tableView.backgroundColor = AppColors.tableViewColor
            tableView.register(UINib(nibName:cellString, bundle: nil), forCellReuseIdentifier: cellString)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Track your workout!"
        lineChart.chartDescription?.enabled = false
        lineChart.dragEnabled = true
        lineChart.setScaleEnabled(true)
        lineChart.zoomOut()
        lineChart.pinchZoomEnabled = true
//        let l = lineChart.legend
//        l.form = .empty
//        l.font = UIFont.systemFont(ofSize: 18, weight: .regular)
//        l.textColor = .red
//        l.horizontalAlignment = .left
//        l.verticalAlignment = .bottom
//        l.orientation = .horizontal
//        l.drawInside = false
        
        
        let xAxis = lineChart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        //xAxis.labelTextColor = .red
        xAxis.labelTextColor = .clear
        xAxis.drawAxisLineEnabled = false
        
        let leftAxis = lineChart.leftAxis
        leftAxis.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        leftAxis.axisMaximum = Double(upperLimit + 200)
        leftAxis.axisMinimum = Double(lowerLimit - 200)
        //leftAxis.drawGridLinesEnabled = true
        //leftAxis.getRequiredHeightSpace()
//        leftAxis.calculate(min: Double(lowerLimit), max: Double(upperLimit))
        leftAxis.granularityEnabled = true
        
       
        let rightAxis = lineChart.rightAxis
        //rightAxis.drawri
        rightAxis.labelTextColor = .clear
        rightAxis.axisMaximum = Double(upperLimit)
        rightAxis.axisMinimum = Double(lowerLimit)
        rightAxis.granularityEnabled = false
        lineChart.animate(xAxisDuration: 2.5)
        
        FirebaseDataService.instance.getSingalData(eventType: .value) { [weak self]  (sensorValue) in
            guard let this = self else {return}
            guard sensorValue > 0 else {
                Toast.showToast(superView: this.view
                                , message: "No sensor data found")
                return
            }
            this.sensorValues.append(sensorValue)
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Go"), object: self, queue: .main) { [weak self](_) in
            guard let self = self else {return}
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateGraphValues), userInfo: nil, repeats: true)
        }
    }


    
    @IBAction func goBtnTapped(_ sender:UIButton)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Go"), object: self)
    }
    
    @IBAction func stopBtnTapped(_ sender:UIButton)
    {
        timer?.invalidate()
        testResults.append(TrackTimeModel(testName:testName.text ?? "",good: "34%", poorFlex: "44%", poorExt: "55%"))
        tableView.reloadData()
    }
    
    @objc func updateGraphValues(){
        FirebaseDataService.instance.getSingalData(eventType: .value) { [weak self]  (sensorValue) in
            guard let this = self else {return}
            guard sensorValue > 0 else {
                Toast.showToast(superView: this.view
                                , message: "No sensor data found")
                return
            }
            this.sensorValues.append(sensorValue)
            this.setData(data: this.sensorValues)
        }
    }
    

    
    func setData(data:[Int]){
        var enteris = [ChartDataEntry]()
        for i in 0..<data.count{
            enteris.append(ChartDataEntry(x: Double(i), y: Double(data[i])))
        }
        print("Enteris",enteris.debugDescription)
        let set1 = LineChartDataSet(entries: enteris, label: "Sensor Data")
        set1.lineWidth = 3
        set1.valueTextColor = .clear
        set1.mode = .horizontalBezier
        set1.drawCirclesEnabled = false
        set1.drawCircleHoleEnabled = false
        let data = LineChartData(dataSet: set1)
        lineChart.data = data
        
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.endEditing(true)
        testName.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == testName{
            self.view.endEditing(true)
            testName.resignFirstResponder()
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Go"), object: self)
        }
        return true
    }
    
}

extension TrackTimeGraph:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath) as! TextResultCell
        cell.layer.cornerRadius = 10
        cell.data = testResults[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
