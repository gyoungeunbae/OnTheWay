//
//  MenuPageViewController.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 11..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit
import PageMenu

class MenuPageViewController: UIViewController, CAPSPageMenuDelegate {
    
    var pageMenu : CAPSPageMenu?
    var calenderManager = CalenderManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var controllerArray : [MyPathViewController] = []
        var weekDay = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        var weekArrStr = calenderManager.getWeekArrStr()
        let storyboard = UIStoryboard(name: "MyPath", bundle: nil)
        let sunPathVC: MyPathViewController = storyboard.instantiateViewController(withIdentifier: "myPathVC") as! MyPathViewController
        let monPathVC: MyPathViewController = storyboard.instantiateViewController(withIdentifier: "myPathVC") as! MyPathViewController
        let tuePathVC: MyPathViewController = storyboard.instantiateViewController(withIdentifier: "myPathVC") as! MyPathViewController
        let wedPathVC: MyPathViewController = storyboard.instantiateViewController(withIdentifier: "myPathVC") as! MyPathViewController
        let thuPathVC: MyPathViewController = storyboard.instantiateViewController(withIdentifier: "myPathVC") as! MyPathViewController
        let friPathVC: MyPathViewController = storyboard.instantiateViewController(withIdentifier: "myPathVC") as! MyPathViewController
        let satPathVC: MyPathViewController = storyboard.instantiateViewController(withIdentifier: "myPathVC") as! MyPathViewController
        
        controllerArray = [sunPathVC, monPathVC, tuePathVC, wedPathVC, thuPathVC, friPathVC, satPathVC]
        for index in 0..<controllerArray.count {
            controllerArray[index].title = weekDay[index]
            controllerArray[index].today = weekArrStr[index]
        }
        
        var parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.1)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        self.view.addSubview(pageMenu!.view)

        // Do any additional setup after loading the view.
    }
    
    
    

}
