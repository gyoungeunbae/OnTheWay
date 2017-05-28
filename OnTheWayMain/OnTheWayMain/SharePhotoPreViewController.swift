import UIKit
import Foundation

class SharePhotoPreViewController: UIViewController {
    

   
 
    @IBOutlet weak var today: UILabel!
  
    @IBOutlet weak var sharePhototitle: UILabel!
    var capturedImage : UIImage?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var square: UIView!
    @IBOutlet weak var steps: UILabel!
    let stepManager = StepManager()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
 //       capturedImage.
        let calender = CalenderManager()
        self.square.layer.borderWidth = 1.0
        self.square.layer.borderColor = UIColor.white.cgColor
        let impDate = (calender.myDate)
        let weeklyStepsDic = StepManager.sharedInstance.getWeeklyStepsDic()
        
        
        DispatchQueue.main.async {
            
            let steps: Int = weeklyStepsDic[6]!
            let getStep = steps
            self.steps.text = String(describing: getStep)
        }
        
        
        
        today.text = calender.getTodayString(todayDate: (impDate))
        
        
        imageView.image = capturedImage
        imageView.addSubview(square)
        imageView.addSubview(sharePhototitle)
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 80))
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "");
        let backItem = UIBarButtonItem(title: "< Camera", style: .plain, target: self, action: #selector(backAction))
        navItem.leftBarButtonItem = backItem
        navBar.setItems([navItem], animated: false);
        
    }
    
    func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    @IBAction func savaImage(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(imageView.snapshot()
            , self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    

}
extension UIView {
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
