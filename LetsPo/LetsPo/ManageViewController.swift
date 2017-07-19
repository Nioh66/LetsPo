//
//  ManageViewController.swift
//  LetsPo
//
//  Created by 溫芷榆 on 2017/7/19.
//  Copyright © 2017年 Walker. All rights reserved.
//

import UIKit

let identifier = "identifier"

class ManageViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, ActionDelegation, ScrollPagerDelegate {
    
    @IBOutlet weak var scrollPager: ScrollPager!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var deleteBtnFlag:Bool!
    
    var recent:NSMutableArray = []
    var nearby:NSMutableArray = []
    var all:NSMutableArray = []
    
    var collectionViewTwo:UICollectionView!
    var collectionViewOne: UICollectionView!
    var collectionViewThree:UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // register three collectionView
        collectionViewOne = UICollectionView(frame: self.view.frame, collectionViewLayout: FlowLayout())
        collectionViewOne.register(UINib.init(nibName: "ManageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        collectionViewOne.backgroundColor = UIColor.clear
        collectionViewOne.delegate = self
        collectionViewOne.dataSource = self
        scrollView.addSubview(collectionViewOne)
        
        
        collectionViewTwo = UICollectionView(frame: self.view.frame, collectionViewLayout: FlowLayout())
        collectionViewTwo.register(UINib.init(nibName: "ManageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        collectionViewTwo.delegate = self
        collectionViewTwo.dataSource = self
        collectionViewTwo.backgroundColor = UIColor.clear
        self.view.addSubview(collectionViewTwo)
        
        collectionViewThree = UICollectionView(frame: self.view.frame, collectionViewLayout: FlowLayout())
        collectionViewThree.register(UINib.init(nibName: "ManageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        collectionViewThree.delegate = self
        collectionViewThree.dataSource = self
        collectionViewThree.backgroundColor = UIColor.clear
        self.view.addSubview(collectionViewThree)
        
        // temporary content image
        nearby = NSMutableArray(objects:"deer.jpg","deer.jpg","deer.jpg","deer.jpg")
        all = NSMutableArray(objects:"deer.jpg","deer.jpg","deer.jpg","deer.jpg")
        
        recent = NSMutableArray(objects:"deer.jpg","deer.jpg","deer.jpg","deer.jpg")
        
        
        setFlagAndGsr()
        
        // assign view to each page
        scrollPager.delegate = self
        scrollPager.addSegmentsWithTitlesAndViews(segments: [
            ("RECENT", collectionViewOne),
            ("NEARBY", collectionViewTwo),
            ("ALL", collectionViewThree),
            ])
        
        
        
    }
    
    
    // set frame for scroll view
    override func viewDidLayoutSubviews() {
        scrollView.frame = CGRect(x: 0.0, y: 0.0, width: contentView.bounds.size.width, height: view.bounds.size.height)
        
    }
    
    
    func scrollPager(scrollPager: ScrollPager, changedIndex: Int) {
        print("scrollPager index changed: \(changedIndex)")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = Int()
        
        if collectionView == self.collectionViewOne {
            count = recent.count
        }
        else if collectionView == self.collectionViewTwo {
            count = nearby.count
        }else if collectionView == self.collectionViewThree {
            count = all.count
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = ManageCollectionViewCell()
        
        if collectionView == self.collectionViewOne {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ManageCollectionViewCell
            let imageString = recent[indexPath.item]
            cell.backdroundImage.image = UIImage(named: imageString as! String)
            setCellVibrate(cell: cell, path: indexPath)
            
        }else if collectionView == self.collectionViewTwo {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ManageCollectionViewCell
            let imageString = nearby[indexPath.item]
            cell.backdroundImage.image = UIImage(named: imageString as! String)
            setCellVibrate(cell: cell, path: indexPath)
        }else if collectionView == self.collectionViewThree {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ManageCollectionViewCell
            let imageString = all[indexPath.item]
            cell.backdroundImage.image = UIImage(named: imageString as! String)
            setCellVibrate(cell: cell, path: indexPath)
        }
        
        return cell
    }
    
    //Mark: - remove object form indexPath
    func deleteCell(_ cell: UICollectionViewCell) {
        
        if let indexPath = collectionViewOne.indexPath(for: cell) {
            recent.removeObject(at: indexPath.row)
            collectionViewOne.deleteItems(at: [indexPath])
        }else if let indexPath = collectionViewTwo.indexPath(for: cell) {
            nearby.removeObject(at: indexPath.row)
            collectionViewTwo.deleteItems(at: [indexPath])
        }else if let indexPath = collectionViewThree.indexPath(for: cell) {
            all.removeObject(at: indexPath.row)
            collectionViewThree.deleteItems(at: [indexPath])
        }
        // I might suggest making `cellArray` a Swift array rather than a `NSMutableArray`
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.section),\(indexPath.item)")
        //        準備下一頁
      performSegue(withIdentifier:"manageDetail", sender: self)
        
    }
    
    func setFlagAndGsr(){
        deleteBtnFlag = true
        addDoubleTapGesture()
    }
    
    func setCellVibrate(cell:ManageCollectionViewCell, path:IndexPath){
        
        if deleteBtnFlag == true {
            cell.deleteBtn.isHidden = true
        }else {
            cell.deleteBtn.isHidden = false
        }
        cell.delegation = self
    }
    
    func handleDoubleTap(gestureRecognizer:UITapGestureRecognizer){
        hideAllDeleteBtn()
    }
    
    func addDoubleTapGesture(){
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(gestureRecognizer:)))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
    }
    
    func hideAllDeleteBtn() {
        if !deleteBtnFlag{
            deleteBtnFlag = true
            collectionViewOne.reloadData()
            collectionViewTwo.reloadData()
            collectionViewThree.reloadData()
        }
    }
    
    func showAllDeleteBtn(){
        deleteBtnFlag = false
        collectionViewOne.reloadData()
        collectionViewTwo.reloadData()
        collectionViewThree.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}
