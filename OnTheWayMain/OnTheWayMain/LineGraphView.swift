

import UIKit

class LineGraphView: UIView {
    
    var count: CGFloat = 0.0
    var graphValues: Array<CGFloat> = [10003,13000,7000,3500,8000,8000,0]
    let π: CGFloat = CGFloat.pi
    var point = [CGPoint]()
    var setDayDotLine = [UIBezierPath]()
    var goalValue: CGFloat = 100.0
    var goalRate: CGFloat = 0.01
    var selectedDayLine: Int = 6
    

    override func draw(_ rect: CGRect) {
        
        let circle = UIGraphicsGetCurrentContext()
        let dotLineGoal = UIBezierPath()
        let dotLineZero = UIBezierPath()
       
        let pattern: [CGFloat] = [5.0, 5.0]
        let valueGap = Int((bounds.size.width) / 7)
       
        
        
        for index in 0...6 {
            setDayDotLine.append(UIBezierPath())
            setDayDotLine[index].move(to: CGPoint(x: 30 + CGFloat(valueGap * index), y: bounds.size.height * 0.5))
            setDayDotLine[index].addLine(to: CGPoint(x: 30 + CGFloat(valueGap * index), y: (bounds.size.height * 0.5) - bounds.size.height * 0.7))

            if(selectedDayLine == index){
                
                UIColor.white.setStroke()
                setDayDotLine[index].lineWidth = 2.0
                setDayDotLine[index].stroke()
                
            } else {
                
                UIColor.black.setStroke()
                setDayDotLine[index].lineWidth = 1.0
                setDayDotLine[index].stroke()
                
            }
            
        }
        
        dotLineGoal.move(to: CGPoint(x: 10, y: (bounds.size.height * 0.5) - goalValue))
        dotLineGoal.addLine(to: CGPoint(x:bounds.size.width - 10, y: (bounds.size.height * 0.5) - goalValue))
        dotLineZero.move(to: CGPoint(x: 10, y: bounds.size.height * 0.5 ))
        dotLineZero.addLine(to: CGPoint(x:bounds.size.width - 10, y: bounds.size.height * 0.5))
        
        dotLineGoal.setLineDash(pattern, count: 2, phase: 0.0)
        UIColor.green.setStroke()
        dotLineGoal.stroke()
        dotLineZero.setLineDash(pattern, count: 2, phase: 0.0)
        UIColor.white.setStroke()
        dotLineZero.stroke()
        
        for index in 0...6 {
            
            point.append(CGPoint())
            point[index] = CGPoint(x: 30 + CGFloat(valueGap * index), y: ((bounds.size.height * 0.5)-(graphValues[index] * goalRate)))
            
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
            circle?.addArc(center: CGPoint(x: 30 + CGFloat(valueGap * index), y: ((bounds.size.height * 0.5) - graphValues[index] * goalRate)), radius: 5, startAngle: 3 * π / 2, endAngle: 7 * π / 2, clockwise: false)
            if(graphValues[index] >= 10000){
                circle?.setFillColor(UIColor.green.cgColor)
            } else {
                circle?.setFillColor(UIColor.yellow.cgColor)
            }
            
            circle?.fillPath()
        }
    }
    
    func setGoalValue(goal: CGFloat) {
        goalValue = goal / 100
        setGoalRate(goal: goalValue)
    }
    
    func setGoalRate(goal: CGFloat){
        goalRate = 1 / goalValue
    }
    
    func setSelectedDayLine(value: Int) {
        selectedDayLine = value
    }
    
       
    
}
