//
//  PersonalDetailVC.swift
//  LetsPo
//
//  Created by 溫芷榆 on 2017/7/23.
//  Copyright © 2017年 Walker. All rights reserved.
//

import UIKit

class PersonalDetailVC: UIViewController {

    
    @IBOutlet weak var selfDataTable: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        setPersonalImage()
        setLabelWithFrame()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setLabelWithFrame(){
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        nameLabel.frame = CGRect(x: 0, y: self.view.center.y * 0.70, width: UIScreen.main.bounds.size.width, height: 30)
      }
    func setPersonalImage(){
        let personalImage = UIImageView()
        personalImage.frame = CGRect(x: self.view.center.x - 75, y: 75, width: 150, height: 150)
        personalImage.backgroundColor = UIColor.black
        personalImage.layer.cornerRadius = personalImage.frame.size.width / 2
        
        view.addSubview(personalImage)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationItem.title = "個人資料"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnAction))
        
        
    }
    func editBtnAction(){
        let nextPage = storyboard?.instantiateViewController(withIdentifier: "InfoEditViewController") as? InfoEditVC
        nextPage?.navigationItem.leftItemsSupplementBackButton = true
        navigationController?.pushViewController(nextPage!, animated: true)
    }


}
