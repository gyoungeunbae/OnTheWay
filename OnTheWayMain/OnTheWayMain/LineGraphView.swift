

import UIKit

class LineGraphView: UIView {
    var count: CGFloat = 0.0
    var graphValues: Array<CGFloat> = [8000,8000,8000,8000,8000,8000,8000]
    let π: CGFloat = CGFloat.pi
    var point = [CGPoint]()
    
    override func draw(_ rect: CGRect) {
        let x = 30
        
        
        
        var circle = UIGraphicsGetCurrentContext()
        
        
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 0.0, 1.0]
        let color = CGColor(colorSpace: colorSpace, components: components)
        
       
        
        for index in 0...6 {
            circle?.addArc(center: CGPoint(x: CGFloat(x + (50 * index)), y: graphValues[index] * 0.01), radius: 10, startAngle: 3 * π / 2, endAngle: 7 * π / 2, clockwise: false)
            circle?.setFillColor(UIColor.green.cgColor)
            
    
            
        
            circle?.fillPath()
            
            point.append(CGPoint())
            point[index] = CGPoint(x: CGFloat(x + (50 * index)), y: graphValues[index] * 0.01)
        }
        
        for index in 0...5{
            let context = UIGraphicsGetCurrentContext()
            
            context?.setStrokeColor(UIColor.green.cgColor)
            context?.setLineWidth(3.0)
            
            context?.move(to: point[index])
            
            context?.addLine(to: point[index + 1])
            
            context?.strokePath()
            
            context?.setLineWidth(4.0)
        }
    }
}
