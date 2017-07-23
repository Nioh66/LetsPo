//
//  PersnalDetailViewController.swift
//  LetsPo
//
//  Created by 溫芷榆 on 2017/7/23.
//  Copyright © 2017年 Walker. All rights reserved.
//

import UIKit

class PersnalDetailViewController: UIViewController {

    @IBOutlet weak var ID: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mail: UILabel!
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
        idLabel.frame = CGRect(x: self.view.center.x, y: 310, width: 200, height: 30)
        mailLabel.frame = CGRect(x: self.view.center.x, y: 360, width: 200, height: 30)
        ID.frame = CGRect(x: self.view.center.x - 50, y: 310, width: 50, height: 30)
        mail.frame = CGRect(x: self.view.center.x - 65, y: 360, width: 50, height: 30)
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
        let nextPage = storyboard?.instantiateViewController(withIdentifier: "InfoEditViewController") as? InfoEditViewController
        nextPage?.navigationItem.leftItemsSupplementBackButton = true
        navigationController?.pushViewController(nextPage!, animated: true)
    }


}
