//
//  FirebaseDataService.swift
//  BackAware
//
//  Created by Muhammad Ali on 13/04/2021.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
final class FirebaseDataService{
    
    static let instance = FirebaseDataService()
    private var ref : DatabaseReference? = nil
    private init(){}
    
    func configureReference(){
        ref = Database.database().reference(withPath: currentUserId)
    }
    func getData(eventType:DataEventType = .value,complicationHandler:@escaping ((Int)->Void))
    {
        if eventType == .value {
            ref?.child(FirebaseDbPaths.sensorData).observe(eventType, with: { (snapshot) in
                if let dic = snapshot.value as? [String:Any]{
                    let data1 = dic["Data1"] as? Int ?? 0
                    complicationHandler(data1)
                }
            })
        }else{
            ref?.child(FirebaseDbPaths.sensorData).observe(eventType, with: { (snapshot) in
                if let dic = snapshot.value as? Int{
                    //let data1 = dic["Data1"] as? Int ?? 0
                    complicationHandler(dic)
                }
            })
        }
        
    }
    func storeUserDevice(path:String,value:[String:Any])
    {
        Database.database().reference(withPath: path).childByAutoId().setValue(value)
    }
    func getCalibrationData(eventType:DataEventType = .value,complicationHandler:@escaping (((Int,Int))->Void))
    {
    
        ref?.child(FirebaseDbPaths.calibrate).observeSingleEvent(of: eventType, with: { (snapshot) in
            if let dic = snapshot.value as? [String:Any]{
                let data1 = dic["Flex1Limit"] as? Int ?? 0
                let data2 = dic["Flex2Limit"] as? Int ?? 0
//                let data3 = dic["poorFlex"] as? Int ?? 0
                complicationHandler((data1,data2))
            }
        })
    }
    
    func setData(path:String=FirebaseDbPaths.sensorData,value:[String:Any])
    {
        ref?.child(path).setValue(value)
    }
    func updateData(path:String=FirebaseDbPaths.sensorData,value:[String:Any])
    {
        ref?.child(path).updateChildValues(value)
    }
    
    
    func verifyPhoneNumber(with phoneNumber:String,complicationHandler:@escaping ((Result<String,Error>)->Void))
    {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
            if let error = error{
                complicationHandler(.failure(error))
            }else{
                guard let id = verificationId else{
                    let error = NSError(domain: "", code: 405, userInfo: [NSLocalizedDescriptionKey:"Invalid Verification Id"])
                    return complicationHandler(.failure(error))
                }
                complicationHandler(.success(id))
            }
        }
    }
    
    func verifyOTP(with id:String,verificationCode:String,complicationHandler:@escaping ((Result<String,Error>)->Void))
    {
        let provider = PhoneAuthProvider.provider().credential(withVerificationID: id, verificationCode: verificationCode)
        Auth.auth().signIn(with: provider) { (authResult, error) in
          if let error = error {
            let authError = error as NSError
            complicationHandler(.failure(authError))
            return
          }else{
            complicationHandler(.success(Auth.auth().currentUser?.uid ?? ""))
          }
        }
    }
    
    func checkUserSession(complicationHandler:@escaping ((Result<String,Error>)->Void)){
        guard let id = UIDevice.current.identifierForVendor?.uuidString else {return}
        Database.database().reference(withPath: id).observe(.value) { (snapshot) in
            if let _ = snapshot.value as? [String:Any]{
                let id = Auth.auth().currentUser?.uid ?? ""
                complicationHandler(.success(id))
            }else{
                let error = NSError(domain: "", code: 405, userInfo: [NSLocalizedDescriptionKey:"No User Found"])
                complicationHandler(.failure(error))
            }
        } withCancel: { (err) in
            complicationHandler(.failure(err))
        }

    }
    
    
    func getPieStatisticsData(complicationHandler:@escaping (([Int])->Void))
    {
        ref?.child(FirebaseDbPaths.statistics)
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
        ref?.child(FirebaseDbPaths.trackingTime)
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
        ref?.removeAllObservers()
    }
}


struct TrackModel: Codable {
    let trackingTime:String
    let tt:Int
}
