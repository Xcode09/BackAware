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
                let data1 = dic["Data1"] as! Int
                complicationHandler(data1)
            }
        })
    }
}
