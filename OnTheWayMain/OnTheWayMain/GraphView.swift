

import UIKit

class GraphView: UIView {
    var count: CGFloat = 0.0
    var graphValues: Array<CGFloat> = [8000,8000,8000,8000,8000,8000,8000]
    
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
        
        for index in 0...6 {

            let rectangle = CGRect(x: x + (50 * index) ,y: Int(bounds.size.height * 0.8),width: 25,height: Int(-graphValues[index] * 0.01))

            context?.addRect(rectangle)
            
            context?.strokePath()
            
            if (graphValues[index] >= 10000) {
                context?.setFillColor(UIColor.green.cgColor)
                context?.fill(rectangle)
            } else {
                context?.setFillColor(UIColor.yellow.cgColor)
                context?.fill(rectangle)

            }
            
        }
    }
}
