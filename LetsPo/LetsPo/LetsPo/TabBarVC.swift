//
//  TabBarVC.swift
//  LetsPo
//
//  Created by Pin Liao on 25/07/2017.
//  Copyright © 2017 Walker. All rights reserved.
//

import UIKit
import CoreData
var noteDataManager:CoreDataManager<NoteData> = CoreDataManager.init(initWithModel: "LetsPoModel",
                                                                        dbFileName: "LetsPo.sqlite",
                                                                        dbPathURL: nil,
                                                                        sortKey: "note_ID",
                                                                        entityName: "NoteData")
var boardDataManager:CoreDataManager<BoardData> = CoreDataManager.init(initWithModel: "LetsPoModel",
                                                                          dbFileName: "LetsPo.sqlite",
                                                                          dbPathURL: nil,
                                                                          sortKey: "board_CreateTime",
                                                                          entityName: "BoardData")
var memberDataManager:CoreDataManager<MemberData> = CoreDataManager.init(initWithModel: "LetsPoModel",
                                                                        dbFileName: "LetsPo.sqlite",
                                                                        dbPathURL: nil,
                                                                        sortKey: "member_ID",
                                                                        entityName: "MemberData")






class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
