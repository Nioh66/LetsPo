//
//  DragBoardVC.swift
//  LetsPo
//
//  Created by Pin Liao on 2017/7/18.
//  Copyright © 2017年 Walker. All rights reserved.
//

import Foundation
import UIKit

class DragBoardVC: UIViewController {
    
  //  @IBOutlet weak var boardBackgroundImage: UIImageView!
  //  let sendBgImageNN = Notification.Name("sendBgImage")
    var topBgImages:UIImage?
    
    @IBOutlet weak var topImage: UIImageView!
    var thePost:Note!

    var posterX:CGFloat = 150
    var posterY:CGFloat = 150
    let posterEdge:CGFloat = 100

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topImage.image = topBgImages
        
        self.view.sendSubview(toBack: topImage)
        
        
        
//        var postIt = Note()
//        postIt.frame = CGRect(x: posterX,
//                              y: posterY,
//                              width: posterEdge,
//                              height: posterEdge)
//        
//        postIt = thePost
//        postIt.shapeLayer.fillColor = UIColor.red.cgColor
//
//        self.view.addSubview(postIt)
//
        
        
    }
}

    




