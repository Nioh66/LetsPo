//
//  DragBoardVC.swift
//  LetsPo
//
//  Created by Pin Liao on 2017/7/18.
//  Copyright © 2017年 Walker. All rights reserved.
//

import Foundation
import UIKit

class DragBoardVC: UIViewController ,UINavigationControllerDelegate{
    
  //  @IBOutlet weak var boardBackgroundImage: UIImageView!
  //  let sendBgImageNN = Notification.Name("sendBgImage")
    var topBgImages:UIImage?
    
    @IBOutlet weak var topImage: UIImageView!
    var thePost:Note!
    var resizeNote:UIImage!
    var NoteImageView = UIImageView()
    let posterX:CGFloat = 150
    let posterY:CGFloat = 150
    let posterEdge:CGFloat = 100
    let resetNote = Notification.Name("resetNote")
       
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
               
        self.tabBarController?.tabBar.isHidden = false
        topImage.image = topBgImages
        
       
        NoteImageView.frame = CGRect(x: posterX,
                              y: posterY,
                              width: posterEdge,
                              height: posterEdge)
        NoteImageView.image = resizeNote
        topImage.addSubview(NoteImageView)

        NoteImageView.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panTheNote))
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        NoteImageView.addGestureRecognizer(panGesture)
    }
    
    
    
    func colorConvert(color: CGColor?) -> Data?{
        var colorData:Data?
        
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as! Data
        }
        
        
       return colorData
    }
    
    
    @IBAction func finishBtn(_ sender: UIButton) {

//        print("\(String(describing:UIColor.blue))")
        
        
//       let noteItem = noteDataManager.createItem()
//        noteItem.note_X = Int64(NoteImageView.frame.minX)
//        noteItem.note_Y = Int64(NoteImageView.frame.minY)
//        noteItem.note_BgColor = thePost.shapeLayer.fillColor as! String
//          noteItem.note_Content =
//      noteItem.note_FontColor
//      noteItem.note_FontSize
    print(self.colorConvert(color: UIColor.red.cgColor))
        
        
        NotificationCenter.default.post(name: resetNote, object: nil, userInfo: nil)
            tabBarController?.selectedIndex = 1
        navigationController?.popToRootViewController(animated: true)

    }
    
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.navigationBar.isHidden = false

        navigationController?.popViewController(animated: true)

    }
    
    func panTheNote(sender:UIPanGestureRecognizer) {
        
        let point = sender.location(in: topImage)
        
        
        NoteImageView.center = point
    }
  }

    




