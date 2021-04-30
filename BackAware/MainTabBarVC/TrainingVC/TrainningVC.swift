//
//  TrainningVC.swift
//  BackAware
//
//  Created by Muhammad Ali on 16/04/2021.
//

import UIKit
import RxSwift
import RxCocoa


struct TrainningModel {
    let title:String
    let freePlan:String
    let descriptionTitle:String
    let image:UIImage
}

private struct TrainningViewModel {
    var items = PublishSubject<[Plan]>()
    
    func fetchData(){
        guard let path = Bundle.main.path(forResource: "trainings", ofType: "json") else { print("Errr")
            return
        }
        do{
            let uri = URL(fileURLWithPath: path)
            let data = try Data(contentsOf:uri)
            let js = try JSONDecoder.init().decode(PlanModel.self, from: data)
            if let plansArr = js.trainings{
                items.onNext(plansArr)
                items.onCompleted()
                
            }
        }
        catch let err{
            print("Err",err)
        }
        

    }
}
private let reuseIdentifier = "TrainingCell"
private let myHeaderFooterClass = "MyHeaderFooterClass"
class TrainningVC: UICollectionViewController,UICollectionViewDelegateFlowLayout{
    private var dataSource = TrainningViewModel()
    
    private var bag = DisposeBag()
    private lazy var items = [Plan]()
    fileprivate func configureCollectionView() {
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
        // Register cell classes
        //self.collectionView.delegate = nil
        self.navigationItem.title = "Trainings"
        //self.collectionView.dataSource = nil
        self.collectionView.backgroundColor = AppColors.bgColor
        self.collectionView!.register(UINib(nibName:reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(MyHeaderFooterClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: myHeaderFooterClass)
       
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()

        // Do any additional setup after loading the view.
        
//        collectionView.rx.modelSelected(Plan.self)
//            .subscribe(onNext: { [weak self] model in
//                guard let self = self else { return }
//
//            }).disposed(by: bag)
//
//        dataSource.items.bind(to: collectionView.rx.items(cellIdentifier: reuseIdentifier, cellType: TrainingCell.self))
//        {
//            [weak self]item,model,cell in
//            cell.data = model
//            //self?.cellAnimate(cell: cell)
//            cell.applyCardView(cornerRadius: 8)
//        }.disposed(by: bag)
//
        fetchData()
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TrainingCell
        cell.data = items[indexPath.item]
        cell.applyCardView(cornerRadius: 8)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TrainingDetailVC(collectionViewLayout: UICollectionViewFlowLayout())
        vc.plan = items[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: myHeaderFooterClass, for: indexPath) as! MyHeaderFooterClass
        headerView.titleLabel.text = "Workout Collection".uppercased()
        headerView.backgroundColor = AppColors.bgColor
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width - 20, height: collectionView.frame.width/1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height:40)
    }

    
    private func cellAnimate(cell:UICollectionViewCell){
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut) {
            cell.isHidden = true
        } completion: { (true) in
            cell.isHidden = false
        }

    }
   
    func fetchData(){
        guard let path = Bundle.main.path(forResource: "trainings", ofType: "json") else { print("Errr")
            return
        }
        do{
            let uri = URL(fileURLWithPath: path)
            let data = try Data(contentsOf:uri)
            let js = try JSONDecoder.init().decode(PlanModel.self, from: data)
            if let arr = js.trainings{
                items = arr
                DispatchQueue.main.async {
                    [weak self] in
                    self?.collectionView.reloadData()
                }
            }
        }
        catch let err{
            print("Err",err)
        }
        

    }
}
class MyHeaderFooterClass: UICollectionReusableView {

    let titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = AppColors.labelColor
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lbl.textAlignment = .left
        return lbl
    }()
 override init(frame: CGRect) {
    super.init(frame: frame)
    //self.backgroundColor = UIColor.purple

    // Customize here
    addSubview(titleLabel)
    titleLabel.frame = self.bounds

 }

 required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

 }
}
