//
//  accountViewController.swift
//  LetsPo
//
//  Created by 溫芷榆 on 2017/7/23.
//  Copyright © 2017年 Walker. All rights reserved.
//

import UIKit

class AccountVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
     let cellTitle = ["個人資料","通知管理","好友管理"]

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var personalName: UILabel!
    @IBOutlet weak var personalImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        //        cell?.textLabel?.frame(forAlignmentRect: 10)
        cell?.textLabel?.text = cellTitle[indexPath.row]
        cell?.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        if indexPath.row == 0 {
            let nextPage = storyboard?.instantiateViewController(withIdentifier: "PersnalDetailViewController") as? PersonalDetailVC
            nextPage?.navigationItem.leftItemsSupplementBackButton = true
            navigationController?.pushViewController(nextPage!, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        personalImage.frame = CGRect(x: self.view.center.x - 75, y: 75, width: 150, height: 150)
        personalImage.backgroundColor = UIColor.black
        personalImage.layer.cornerRadius = personalImage.frame.size.width / 2
        
        personalName.font = UIFont.systemFont(ofSize: 25)
        personalName.frame = CGRect(x: 0, y: self.view.center.y * 0.70, width: UIScreen.main.bounds.size.width, height: 30)
    }
}
