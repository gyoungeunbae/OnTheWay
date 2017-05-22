

import UIKit

class GraphView: UIView {
    var count: CGFloat = 0.0
    var graphValues: Array<CGFloat> = [8000,8000,8000,8000,8000,8000,8000]
    var colors: Array<CGColor> = [UIColor.red.cgColor,UIColor.orange.cgColor,UIColor.yellow.cgColor,UIColor.green.cgColor,UIColor.blue.cgColor,UIColor.gray.cgColor,UIColor.purple.cgColor]
    
    override func draw(_ rect: CGRect) {
        var x = 30
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineWidth(3.0)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 0.0, 1.0]
        let color = CGColor(colorSpace: colorSpace, components: components)
        
        context?.setStrokeColor(color!)
        
        context?.move(to: CGPoint(x: 0, y: bounds.size.height * 0.8))
        
        context?.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height * 0.8))
        
        context?.strokePath()
        
        context?.setLineWidth(4.0)
        context?.setStrokeColor(UIColor.black.cgColor)
        
        for value in graphValues {

            let rectangle = CGRect(x: x ,y: Int(bounds.size.height * 0.8),width: 25,height: Int(-value * 0.01))
            print(x)

            context?.addRect(rectangle)
            
            context?.strokePath()
            
            context?.setFillColor(UIColor.red.cgColor)
            context?.fill(rectangle)
            
            x += 50
        }
    }
}
