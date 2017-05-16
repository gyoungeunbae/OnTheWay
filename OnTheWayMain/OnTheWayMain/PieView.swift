import UIKit

class PieView: UIView {
    
    var values: Array<CGFloat> = [20,30,40,50]
    var colors: Array<CGColor> = [UIColor.red.cgColor,UIColor.orange.cgColor,UIColor.yellow.cgColor,UIColor.green.cgColor,UIColor.blue.cgColor,UIColor.gray.cgColor,UIColor.purple.cgColor]
    
    
    var count: CGFloat = 0.0
    
    
    override func draw(_ rect: CGRect) {
        
        var countColor = 0
        
        let radius = min(bounds.width/2 - 3.5, bounds.height/2 - 3.5)
        
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        
        let valueCount = values.reduce(0, { x, y in
            x + y
        })
        
        let context = UIGraphicsGetCurrentContext()
        
        
        var startAngle = -CGFloat.pi * 0.5
        
        for x in values {
            count += x
        }
        
        for value in values {
            
            let endAngle = startAngle + 2 * .pi * value / valueCount
            
            context?.move(to: center)
            
            context?.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            
            context?.closePath()
            context?.setLineWidth(3.0)
            
            let strokePath = context?.path?.copy()
            
            context?.setFillColor(colors[countColor])
            countColor += 1
            
            context?.fillPath()
            
            context?.addPath(strokePath!)
            context?.strokePath()
            startAngle = endAngle
            
        }
        
    }
    
    func setValue(valueArr: Array<CGFloat>){
        values = valueArr
    }
    
}
