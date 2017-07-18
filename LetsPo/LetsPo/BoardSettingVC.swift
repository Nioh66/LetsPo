//
//  BoardSettingVC.swift
//  LetsPo
//
//  Created by Pin Liao on 2017/7/18.
//  Copyright © 2017年 Walker. All rights reserved.
//

import Foundation
import UIKit
class BoardSettingVC: UIViewController {
    
    @IBOutlet weak var boardSetting: UIView!
    @IBOutlet weak var boardCheckBtn: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardSetting.layer.cornerRadius = 10.0
        boardCheckBtn.layer.cornerRadius = 10.0
    
    }
}
