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
    var items = PublishSubject<[TrainningModel]>()
    
    func fetchData(){
        let arr = [TrainningModel(title: "Title", freePlan: "Free Plan", descriptionTitle: "Some Short of description", image: #imageLiteral(resourceName: "fitness")),TrainningModel(title: "Title", freePlan: "Free Plan", descriptionTitle: "Some Short of description", image: #imageLiteral(resourceName: "fitness")),TrainningModel(title: "Title", freePlan: "Free Plan", descriptionTitle: "Some Short of description", image: #imageLiteral(resourceName: "fitness")),TrainningModel(title: "Title", freePlan: "Free Plan", descriptionTitle: "Some Short of description", image: #imageLiteral(resourceName: "fitness"))]
        
        items.onNext(arr)
        items.onCompleted()
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
