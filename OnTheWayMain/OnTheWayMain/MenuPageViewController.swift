
import UIKit
import PageMenu

class MenuPageViewController: UIViewController, CAPSPageMenuDelegate {

    var pageMenu: CAPSPageMenu?
    var calenderManager = CalenderManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        var storyboard = UIStoryboard(name: "MyPath", bundle: nil)

        var controllerArray: [MyPathViewController] = []
        var weekDay = calenderManager.getSimpleWeekArrStr()
        var weekArrStr = calenderManager.getWeekArrStr()

        let firstPathVC: MyPathViewController = storyboard.instantiateViewController(withIdentifier: "myPathVC") as! MyPathViewController
        let secondPathVC: MyPathViewController = storyboard.instantiateViewController(withIdentifier: "myPathVC") as! MyPathViewController
        let thirdPathVC: MyPathViewController = storyboard.instantiateViewController(withIdentifier: "myPathVC") as! MyPathViewController
        let fourthPathVC: MyPathViewController = storyboard.instantiateViewController(withIdentifier: "myPathVC") as! MyPathViewController
        let fifthPathVC: MyPathViewController = storyboard.instantiateViewController(withIdentifier: "myPathVC") as! MyPathViewController
        let sixthPathVC: MyPathViewController = storyboard.instantiateViewController(withIdentifier: "myPathVC") as! MyPathViewController
        let seventhPathVC: MyPathViewController = storyboard.instantiateViewController(withIdentifier: "myPathVC") as! MyPathViewController

        controllerArray = [firstPathVC, secondPathVC, thirdPathVC, fourthPathVC, fifthPathVC, sixthPathVC, seventhPathVC]
        for index in 0..<controllerArray.count {
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
