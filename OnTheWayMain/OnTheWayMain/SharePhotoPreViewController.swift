
import UIKit
import Foundation
class SharePhotoPreViewController: UIViewController {
    var capturedImage : UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var square: UIView!
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.square.layer.borderWidth = 1.0
        self.square.layer.borderColor = UIColor.white.cgColor
        let image = drawCustomImage(size: self.view.bounds.size)
        imageView.addSubview(square)
        imageView.image = image
        let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 80))
        self.view.addSubview(navigationBar);
        let navigationItem = UINavigationItem(title: "")
        let backItem = UIBarButtonItem(title: "< Camera", style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backItem
        navigationBar.setItems([navigationItem], animated: false)
        
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
    func drawCustomImage(size: CGSize) -> UIImage? {
        // Setup our context
        let bounds = CGRect(origin: CGPoint.zero, size: size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        // Setup complete, do drawing here
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(5.0)
        
        // Would draw a border around the rectangle
        // context.stroke(bounds)
        
        context.beginPath()
        context.move(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        context.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        context.strokePath()
        
        // Drawing complete, retrieve the finished image and cleanup
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
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
