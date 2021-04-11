//
//  PlanVC.swift
//  BackAware
//
//  Created by Muhammad Ali on 11/04/2021.
//

import UIKit
import RxSwift
import RxCocoa
private let reuseIdentifier = "PlanCell"


struct Model {
    let title:String
}

struct ViewModel {
    var items = PublishSubject<[Model]>()
    
    func fetchData(){
        let arr = [Model(title: "Ali"),Model(title: "hasan"),Model(title: "jafer")]
        
        items.onNext(arr)
        items.onCompleted()
    }
}

class PlanVC: UICollectionViewController,UICollectionViewDelegateFlowLayout{

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()

        // Do any additional setup after loading the view.
        
        dataSource.items.bind(to: collectionView.rx.items(cellIdentifier: reuseIdentifier, cellType: PlanCell.self))
        {
            item,model,cell in
            cell.title.text = model.title
            cell.layer.cornerRadius = 10
        }.disposed(by: bag)
        
        dataSource.fetchData()
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 280)
    }

   
    

}
