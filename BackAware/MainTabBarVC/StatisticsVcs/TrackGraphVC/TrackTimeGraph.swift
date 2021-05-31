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
    private var isGoPress = false
    private var sensorValue = 0
    @IBOutlet weak private var testName:UITextField!{
        didSet{
            testName.delegate = self
            testName.returnKeyType = .go
        }
    }

    @IBOutlet var btns: [UIButton]!{
        didSet{
            btns.forEach { (b) in
                  
                b.layer.cornerRadius = 20
                if b.tag == 0 {
                    b.layer.borderColor = AppColors.bgColor?.cgColor
                }else{
                    if self.traitCollection.userInterfaceStyle == .dark {
                        b.layer.borderColor = UIColor.lightGray.cgColor
                        b.layer.borderWidth = 1
                                // User Interface is Dark
                            } else {
                                // User Interface is Light
                                b.layer.borderColor = UIColor.white.cgColor
                                b.layer.borderWidth = 3
                            }
                }
                
            }
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
        let l = lineChart.legend
        l.form = .line
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        l.textColor = .white
//        l.horizontalAlignment = .left
//        l.verticalAlignment = .bottom
//        l.orientation = .horizontal
//        l.drawInside = false
        
        
        let xAxis = lineChart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelTextColor = UIColor.white
        
        xAxis.drawAxisLineEnabled = false
        
        let leftAxis = lineChart.leftAxis
        leftAxis.labelTextColor = UIColor.white
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
            this.sensorValue = sensorValue
            this.sensorValues.append(sensorValue)
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Go"), object: self, queue: .main) { [weak self](_) in
            guard let self = self else {return}
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateGraphValues), userInfo: nil, repeats: true)
        }
    }


    
    @IBAction func goBtnTapped(_ sender:UIButton)
    {
        guard sensorValue > 0 else {
            Toast.showToast(superView: self.view
                            , message: "No sensor data found")
            return
        }
        isGoPress = !isGoPress
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Go"), object: self)
    }
    
    @IBAction func stopBtnTapped(_ sender:UIButton)
    {
        guard isGoPress != false else {return}
        timer?.invalidate()
        isGoPress = false
        FirebaseDataService.instance.getTrainingTestData{
            [weak self] dataSet in
            let trainingModel = TrackTimeModel(testName: self?.testName.text ?? "", good: "\(dataSet[0])%", poorFlex: "\(dataSet[2])%", poorExt: "\(dataSet[1])%")
            self?.testResults.append(trainingModel)
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
            
        }
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
    
    
    @IBAction func autoCalibrateBtnTapped(_ sender:UIButton)
    {
        if sensorValue > 0 {
            let upperlimit = upperLimit + 200
            let lowerlimit = lowerLimit - 150
            guard upperlimit > lowerlimit else {
                Toast.showToast(superView: self.view, message: "Upper Limit should be getter than lower limit")
                return
            }
            
            let para : [String:Any] =  ["Flex1Limit":upperlimit,"Flex2Limit":lowerlimit,"Time":TimeAndDateHelper.getDate()]
            FirebaseDataService.instance.setData(path: FirebaseDbPaths.calibrate, value: para)
            Toast.showToast(superView: self.view, message: "Auto Calibration Setup Successfully")
        }else{
            Toast.showToast(superView: self.view, message: "No sensor data")
        }
    }
    
    @IBAction func softCalibrateBtnTapped(_ sender:UIButton)
    {
        if sensorValue > 0 {
            let upperlimit = upperLimit + 115
            let lowerlimit = lowerLimit - 75
            guard upperlimit > lowerlimit else {
                Toast.showToast(superView: self.view, message: "Upper Limit should be getter than lower limit")
                return
            }
            
            let para : [String:Any] =  ["Flex1Limit":upperlimit,"Flex2Limit":lowerlimit,"Time":TimeAndDateHelper.getDate()]
            FirebaseDataService.instance.setData(path: FirebaseDbPaths.calibrate, value: para)
            Toast.showToast(superView: self.view, message: "Auto Calibration Setup Successfully")
        }else{
            Toast.showToast(superView: self.view, message: "No sensor data")
        }
    }
    
    func setData(data:[Int]){
        var enteris = [ChartDataEntry]()
        
        for i in 0..<data.count{
            enteris.append(ChartDataEntry(x: Double(i), y: Double(data[i])))
        }
//        let upperSet = ChartDataEntry(x: Double(upperLimit + 200), y: Double(upperLimit + 200))
//        let lowerSet = ChartDataEntry(x: Double(lowerLimit - 200), y: Double(lowerLimit - 200))
        let set1 = setupSetUI(set: LineChartDataSet(entries: enteris, label: "Sensor Data"), color: .purple)
        let set2 = setupSetUI(set: LineChartDataSet(entries: [ChartDataEntry(x: Double(0), y: Double(0))], label: "Upper Limit"), color: .white)
        let set3 = setupSetUI(set: LineChartDataSet(entries: [ChartDataEntry(x: Double(0), y: Double(0))], label: "Lower Limit"), color:.red)
        let data = LineChartData(dataSets: [set1,set2,set3])
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
    
    private func setupSetUI(set:LineChartDataSet,color:NSUIColor? = nil)->LineChartDataSet{
        set.lineWidth = 3
        if color != nil{
            set.setColor(color!)
        }
        set.lineCapType = .butt
        set.valueTextColor = .clear
        set.mode = .linear
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        
        return set
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
