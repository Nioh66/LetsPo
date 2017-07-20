//
//  BoardSettingVC.swift
//  LetsPo
//
//  Created by Pin Liao on 2017/7/18.
//  Copyright © 2017年 Walker. All rights reserved.
//

import Foundation
import UIKit
class BoardSettingVC: UIViewController ,UINavigationControllerDelegate{
    
    @IBOutlet weak var boardSetting: UIView!
    @IBOutlet weak var boardCheckBtn: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardSetting.layer.cornerRadius = 10.0
        boardCheckBtn.layer.cornerRadius = 10.0
    
        let tapToNext = UITapGestureRecognizer(target: self, action: #selector(goToNextPage))
        boardCheckBtn.isUserInteractionEnabled = true
        boardCheckBtn.addGestureRecognizer(tapToNext)

    }

   
    func goToNextPage() {
        let nextVC = storyboard?.instantiateViewController(withIdentifier:"BoardBgImageSetVC") as! BoardBgImageSetVC

       navigationController?.pushViewController(nextVC, animated: true)
//        self.performSegue(withIdentifier: "goBackSetting", sender: self)
//        present(nextVC, animated: false, completion: nil)
    }
}
