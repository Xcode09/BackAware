//
//  PlanVC.swift
//  BackAware
//
//  Created by Muhammad Ali on 11/04/2021.
//

import UIKit
import RxSwift
import RxCocoa
import ViewAnimator
private let reuseIdentifier = "PlanCell"


struct Model {
    let title:String
    let freePlan:String
    let descriptionTitle:String
    let image:UIImage
}

private struct ViewModel {
    var items = PublishSubject<[Model]>()
    
    mutating func fetchData(){
        let arr = [Model(title: "Physio Led Back Rehab Plan", freePlan: "Free Plan", descriptionTitle: "Follow a plan designed by Chartered Physiotherapist", image: #imageLiteral(resourceName: "hiit")),Model(title: "Physio Led Back Rehab Plan", freePlan: "Free Plan", descriptionTitle: "Follow a plan designed by Chartered Physiotherapist", image: #imageLiteral(resourceName: "hiit")),Model(title: "Physio Led Back Rehab Plan", freePlan: "Free Plan", descriptionTitle: "Follow a plan designed by Chartered Physiotherapist", image: #imageLiteral(resourceName: "hiit")),Model(title: "Physio Led Back Rehab Plan", freePlan: "Free Plan", descriptionTitle: "Follow a plan designed by Chartered Physiotherapist", image: #imageLiteral(resourceName: "hiit")),Model(title: "Physio Led Back Rehab Plan", freePlan: "Free Plan", descriptionTitle: "Follow a plan designed by Chartered Physiotherapist", image: #imageLiteral(resourceName: "hiit"))]
        
        items.onNext(arr)
        
        items.onCompleted()
    }
}

class PlanVC: UICollectionViewController,UICollectionViewDelegateFlowLayout
{
    fileprivate func configureCollectionView() {
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView.delegate = nil
        
        //self.collectionView.dataSource = sel
        self.collectionView.backgroundColor = AppColors.bgColor
        self.collectionView!.register(UINib(nibName:reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    var items = [Plan]()
    private let animations = [AnimationType.vector((CGVector(dx: 30, dy: -30)))]
    var initiallyAnimates = false
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        
        fetchData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Plans"
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PlanCell
        
        
        if initiallyAnimates {
            UIView.animate(views: collectionView.orderedVisibleCells, animations:animations,delay: 1)
            DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                self.initiallyAnimates = false
            })
            
        }
        cell.data = items[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width - 20, height: collectionView.frame.width/2)
    }
    
    private func fetchData(){
        
        guard let path = Bundle.main.path(forResource: "plans", ofType: "json") else { return }
        do{
            let uri = URL(fileURLWithPath: path)
            let data = try Data(contentsOf:uri)
            let js = try JSONDecoder.init().decode(PlanModel.self, from: data)
            if let plansArr = js.plans{
                items = plansArr
                initiallyAnimates = true
                DispatchQueue.main.async {
                    
                    self.collectionView.reloadData()
                }
            }
        }
        catch let err{
            print("Err",err)
        }
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PlanDetailVC(collectionViewLayout: UICollectionViewFlowLayout())
        vc.plan = items[indexPath.item]
        self.navigationItem.title = nil
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}




/*
 private var dataSource = ViewModel()
 private var bag = DisposeBag()
 fileprivate func configureCollectionView() {
     // Uncomment the following line to preserve selection between presentations
     // self.clearsSelectionOnViewWillAppear = false
     
     // Register cell classes
     //self.collectionView.delegate = nil
     self.navigationItem.title = "Plans"
     self.collectionView.dataSource = nil
     self.collectionView.backgroundColor = AppColors.bgColor
     self.collectionView!.register(UINib(nibName:reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
     self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
 }
 var initiallyAnimates = false
 override func viewDidLoad() {
     super.viewDidLoad()

     configureCollectionView()
     //let fromAnimation = Animation
     
     
     // Do any additional setup after loading the view.
     
     dataSource.items.bind(to: collectionView.rx.items(cellIdentifier: reuseIdentifier, cellType: PlanCell.self))
     {
         [weak self]item,model,cell in
         cell.data = model
         //self?.initiallyAnimates = true
         cell.applyCardView(cornerRadius: 8)
     }.disposed(by: bag)
     
     dataSource.fetchData()
     
 }
 private let animations = [AnimationType.vector((CGVector(dx: 0, dy: 30)))]
 @objc fileprivate func someFunction() {
     
     
 }
 
 override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
//        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(someFunction), userInfo: nil, repeats: false)
 }

 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     return .init(width: collectionView.frame.width - 20, height: collectionView.frame.width/2)
 }
 
 

 
 private func cellAnimate(cell:UICollectionViewCell){
     UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut) {
         cell.isHidden = true
     } completion: { (true) in
         cell.isHidden = false
     }

 }
 
 
 self.collectionView?.performBatchUpdates({
     UIView.animate(views: self.collectionView!.orderedVisibleCells,
                    animations: self.animations, completion: {
//                                self.initiallyAnimates = false
                    })
 }, completion: nil)

 
 */
