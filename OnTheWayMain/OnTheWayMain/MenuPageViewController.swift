
import UIKit
import PageMenu

class MenuPageViewController: UIViewController, CAPSPageMenuDelegate {

    var pageMenu: CAPSPageMenu?
    var calenderManager = CalenderManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        let myPathStoryboard = UIStoryboard(name: "MyPath", bundle: nil)
        var controllerArray = [UIViewController]()
        var weekDay = calenderManager.getSimpleWeekArrStr()
        var weekArrStr = calenderManager.getWeekArrStr()

        for index in 0...5 {
            controllerArray.append(StaticMapViewController())
            controllerArray[index] = myPathStoryboard.instantiateViewController(withIdentifier: "staticVC") as! StaticMapViewController
            controllerArray[index].title = weekDay[index]
            controllerArray[index].accessibilityHint = weekArrStr[index]
        }
        
        controllerArray.append(MyPathViewController())
        controllerArray[6] = myPathStoryboard.instantiateViewController(withIdentifier: "myPathVC") as! MyPathViewController
        controllerArray[6].title = weekDay[6]
        
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.1)
        ]

        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 20.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        self.view.addSubview(pageMenu!.view)
        //startingPage 설정해주기
        pageMenu?.moveToPage(6)

    }

}
