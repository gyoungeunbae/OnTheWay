import UIKit

//걸음수 관련
//IBDesignable은 코어그래픽을 스토리보드에서 실시간으로 프리뷰 가능하게 한다
@IBDesignable class CounterView: UIView {
    
    var stepOfGoal = 10000
    let π: CGFloat = CGFloat.pi
    var circleLayer: CAShapeLayer!
    
    @IBInspectable var stepOfWalked: Int = 0

    @IBInspectable var outlineColor: UIColor = UIColor.init(red: 27.0/255.0, green: 235.0/255.0, blue: 141.0/255.0, alpha: 1)

    @IBInspectable var counterColor: UIColor = UIColor.white

    
    
    override func draw(_ rect: CGRect) {
        
        // 원의 중심
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        // 반지름
        let radius: CGFloat = max(bounds.width * 0.7, bounds.height * 0.7)
        
        // 두께

        let arcWidth: CGFloat = 10


        // 시작각도, 마침각도
        let startAngle: CGFloat = 3 * π / 2
        let endAngle: CGFloat = 7 * π / 2
        
        // 회전경로 지정
        let path = UIBezierPath(arcCenter: center,
                                radius: radius/2 - arcWidth/2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        // 그리기
        path.lineWidth = arcWidth
        counterColor.setStroke()
        path.stroke()
        
        //사용할 각도
        let angleDifference: CGFloat = 2 * π
        
        //한 걸음당 각도
        let anglePerMin = angleDifference / CGFloat(stepOfGoal)
        
        //오늘 걸은 각도
        let outlineEndAngle = anglePerMin * CGFloat(stepOfWalked) + startAngle

        
        
        //경로 지정
        let outlinePath = UIBezierPath(arcCenter: center, radius: (bounds.width/2 - 2.5) * 0.7 - 1.5 , startAngle: startAngle, endAngle: outlineEndAngle, clockwise: true)

        circleLayer = CAShapeLayer()
        circleLayer.path = outlinePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 5.0;
        
        circleLayer.strokeEnd = 0.0
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
    
        
        
        
        
//        //경로 닫기
//        outlinePath.addArc(withCenter: center, radius: (bounds.width/2 - arcWidth + 2.5) * 0.7 - 1.5 , startAngle: outlineEndAngle, endAngle: startAngle, clockwise: false)
//        
//        //그리기
//        outlineColor.setStroke()
//
//
//        outlinePath.lineWidth = 30.0
//        UIColor.init(red: 27.0/255.0, green: 235.0/255.0, blue: 141.0/255.0, alpha: 1).withAlphaComponent(0.5).setFill()
//
//        outlinePath.stroke()
//        
//        outlinePath.fill()
    }
    
    func animateCircle(duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        circleLayer.add(animation, forKey: "animateCircle")
    }
    
    func getGoal() -> Int{
        return stepOfGoal
    }
    func setGoal(_ goal: Int) {
        stepOfGoal = goal
    }
    
}
