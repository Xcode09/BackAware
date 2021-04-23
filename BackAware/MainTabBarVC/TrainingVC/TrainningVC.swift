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

class TrainningVC: UICollectionViewController,UICollectionViewDelegateFlowLayout{
    private var dataSource = TrainningViewModel()
    
    private var bag = DisposeBag()
    fileprivate func configureCollectionView() {
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
        // Register cell classes
        //self.collectionView.delegate = nil
        self.navigationItem.title = "Trainings"
        self.collectionView.dataSource = nil
        self.collectionView.backgroundColor = AppColors.bgColor
        self.collectionView!.register(UINib(nibName:reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()

        // Do any additional setup after loading the view.
        
        collectionView.rx.modelSelected(Plan.self)
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                let vc = TrainingDetailVC(collectionViewLayout: UICollectionViewFlowLayout())
                vc.plan = model
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: bag)
        
        dataSource.items.bind(to: collectionView.rx.items(cellIdentifier: reuseIdentifier, cellType: TrainingCell.self))
        {
            [weak self]item,model,cell in
            cell.data = model
            //self?.cellAnimate(cell: cell)
            cell.applyCardView(cornerRadius: 8)
        }.disposed(by: bag)
        
        dataSource.fetchData()
        
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
   
    

}
