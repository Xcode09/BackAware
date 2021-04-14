//
//  FirebaseDataService.swift
//  BackAware
//
//  Created by Muhammad Ali on 13/04/2021.
//

import Foundation
import FirebaseDatabase
final class FirebaseDataService{
    
    static let instance = FirebaseDataService()
    private let ref = Database.database().reference(withPath: FirebaseDbPaths.baseUrl)
    private init(){}
    
    
    func getData(complicationHandler:@escaping ((Int)->Void))
    {
        ref.child(FirebaseDbPaths.sensorData).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dic = snapshot.value as? [String:Any]{
                let data1 = dic["Data1"] as? Int ?? 0
                complicationHandler(data1)
            }
        })
    }
    
    
    
    func getPieStatisticsData(complicationHandler:@escaping (([Int])->Void))
    {
        ref.child(FirebaseDbPaths.statistics)
            .observe(.value, with: { (snapshot) in
                if let dic = snapshot.value as? [String:Any]{
                    let data1 = dic["good"] as? Int ?? 0
                    let data2 = dic["poorExtension"] as? Int ?? 0
                    let data3 = dic["poorFlex"] as? Int ?? 0
                    complicationHandler([data1,data2,data3])
                }
            })
    }
    
    
    func getTracKTimeStatisticsData(complicationHandler:@escaping (([TrackModel])->Void))
    {
        var arrData = [TrackModel]()
        ref.child(FirebaseDbPaths.trackingTime)
            .observe(.value, with: { (snapshot) in
                if let dic = snapshot.value as? NSDictionary
                {
                    dic.enumerated().forEach { (index,element) in
                        if let values = element.value as? NSDictionary, let trackData = values.value(forKey: "TT") as? Int,let timeData = element.key as? String{
                            arrData.append(TrackModel(trackingTime: timeData, tt:trackData))
                        }
                    }
                    complicationHandler(arrData)
                }
            })
    }
    
    
    deinit {
        ref.removeAllObservers()
    }
}


struct TrackModel: Codable {
    let trackingTime:String
    let tt:Int
}
