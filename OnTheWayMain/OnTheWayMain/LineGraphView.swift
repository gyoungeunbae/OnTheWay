

import UIKit

class LineGraphView: UIView {
    var count: CGFloat = 0.0
    var graphValues: Array<CGFloat> = [8000,8000,8000,8000,8000,8000,8000]
    let π: CGFloat = CGFloat.pi
    var point = [CGPoint]()
    var setDayDotLine = [UIBezierPath]()
    
    override func draw(_ rect: CGRect) {
        let x = 30
        
        let circle = UIGraphicsGetCurrentContext()
        let dotLineGoal = UIBezierPath()
        let dotLineZero = UIBezierPath()
        
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 0.0, 1.0]
        let color = CGColor(colorSpace: colorSpace, components: components)
        let pattern: [CGFloat] = [5.0, 5.0]
        
        let valueGap = Int((bounds.size.width) / 7)
        
        for index in 0...6 {
            setDayDotLine.append(UIBezierPath())
            setDayDotLine[index].move(to: CGPoint(x: 30 + CGFloat(valueGap * index), y: bounds.size.height * 0.5))
            setDayDotLine[index].addLine(to: CGPoint(x: 30 + CGFloat(valueGap * index), y: (bounds.size.height * 0.5) - bounds.size.height * 0.7))
            setDayDotLine[index].setLineDash(pattern, count: 2, phase: 0.0)
            
            setDayDotLine[index].stroke()
           

        }
        
        dotLineGoal.move(to: CGPoint(x: 10, y: (bounds.size.height * 0.5) - 100))
        dotLineGoal.addLine(to: CGPoint(x:bounds.size.width - 10, y: (bounds.size.height * 0.5) - 100))
        dotLineZero.move(to: CGPoint(x: 10, y: bounds.size.height * 0.5))
        dotLineZero.addLine(to: CGPoint(x:bounds.size.width - 10, y: bounds.size.height * 0.5))
        
        
        
        
        dotLineGoal.setLineDash(pattern, count: 2, phase: 0.0)
        UIColor.green.setStroke()
        dotLineGoal.stroke()
        dotLineZero.setLineDash(pattern, count: 2, phase: 0.0)
        UIColor.white.setStroke()
        dotLineZero.stroke()
        
        
        
        for index in 0...6 {
            
            point.append(CGPoint())
            point[index] = CGPoint(x: 30 + CGFloat(valueGap * index), y: (bounds.size.height * 0.5)-(graphValues[index] * 0.01))
            
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
        
        for index in 0...6 {
            circle?.addArc(center: CGPoint(x: 30 + CGFloat(valueGap * index), y: (bounds.size.height * 0.5) - graphValues[index] * 0.01), radius: 5, startAngle: 3 * π / 2, endAngle: 7 * π / 2, clockwise: false)
            if(graphValues[index] >= 10000){
                circle?.setFillColor(UIColor.green.cgColor)
            } else {
                circle?.setFillColor(UIColor.yellow.cgColor)
            }
            
            circle?.fillPath()
        }
    }
    
    
}
