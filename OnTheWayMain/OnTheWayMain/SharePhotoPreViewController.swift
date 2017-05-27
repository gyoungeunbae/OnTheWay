
import UIKit
import Foundation

class SharePhotoPreViewController: UIViewController {
    
    var capturedImage : UIImage?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var square: UIView!
    override public func viewDidLoad() {
        super.viewDidLoad()
 //       capturedImage.
        self.square.layer.borderWidth = 1.0
        self.square.layer.borderColor = UIColor.white.cgColor
        
        imageView.image = capturedImage
        imageView.addSubview(square)
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
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    
}
