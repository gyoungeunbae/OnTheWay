//
//  Draw2D.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 4. 22..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit

//걸음수 관련
//IBDesignable은 코어그래픽을 스토리보드에서 실시간으로 프리뷰 가능하게 한다
@IBDesignable class CounterView: UIView {

    let stepOfGoal = 10000
    let π: CGFloat = CGFloat.pi

    @IBInspectable var stepOfWalked: Int = 0
    @IBInspectable var outlineColor: UIColor = UIColor.blue

    @IBInspectable var counterColor: UIColor = UIColor.yellow


    override func draw(_ rect: CGRect) {

        // 원의 중심
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)

        // 반지름
        let radius: CGFloat = max(bounds.width, bounds.height)

        // 두께
        let arcWidth: CGFloat = 60

        // 시작각도, 마침각도
        let startAngle: CGFloat = 3 * π / 2
        let endAngle: CGFloat = 7 * π / 2

        // 회전경로 지정
        var path = UIBezierPath(arcCenter: center,
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
        var outlinePath = UIBezierPath(arcCenter: center, radius: bounds.width/2 - 2.5, startAngle: startAngle, endAngle: outlineEndAngle, clockwise: true)


        //경로 닫기
        outlinePath.addArc(withCenter: center, radius: bounds.width/2 - arcWidth + 2.5, startAngle: outlineEndAngle, endAngle: startAngle, clockwise: false)

        //그리기
        outlineColor.setStroke()
        outlinePath.lineWidth = 6.0
        UIColor.green.setFill()
        outlinePath.stroke()
        outlinePath.fill()
    }
}
