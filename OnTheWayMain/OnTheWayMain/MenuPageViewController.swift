
import UIKit
import PageMenu

class MenuPageViewController: UIViewController, CAPSPageMenuDelegate {

    var pageMenu: CAPSPageMenu?
    var calenderManager = CalenderManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        var storyboard = UIStoryboard(name: "MyPath", bundle: nil)

        var controllerArray = [MyPathViewController]()
        var weekDay = calenderManager.getSimpleWeekArrStr()
        var weekArrStr = calenderManager.getWeekArrStr()

        for index in 0...6 {
            controllerArray.append(MyPathViewController())
            controllerArray[index] = storyboard.instantiateViewController(withIdentifier: "myPathVC") as! MyPathViewController
            controllerArray[index].title = weekDay[index]
            controllerArray[index].today = weekArrStr[index]
        }

        var parameters: [CAPSPageMenuOption] = [
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
