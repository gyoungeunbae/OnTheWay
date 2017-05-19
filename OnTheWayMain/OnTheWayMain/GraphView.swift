//
//  GraphView.swift
//  OnTheWayMain
//
//  Created by lee on 2017. 5. 18..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit

class GraphView: UIView {
    var count: CGFloat = 0.0
    var graphValues: Array<CGFloat> = [10,40,20,40,30,50,60]
    var colors: Array<CGColor> = [UIColor.red.cgColor,UIColor.orange.cgColor,UIColor.yellow.cgColor,UIColor.green.cgColor,UIColor.blue.cgColor,UIColor.gray.cgColor,UIColor.purple.cgColor]
    
    
    
    
    
    
    
    override func draw(_ rect: CGRect) {
        var x = 40
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineWidth(3.0)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 0.0, 1.0]
        let color = CGColor(colorSpace: colorSpace, components: components)
        
        context?.setStrokeColor(color!)
        
        context?.move(to: CGPoint(x: 0, y: 400))
        
        context?.addLine(to: CGPoint(x: 400, y: 400))
        
        context?.strokePath()
        
        
        context?.setLineWidth(4.0)
        context?.setStrokeColor(UIColor.black.cgColor)
        
        for value in graphValues {
            
            let rectangle = CGRect(x: x ,y: 398,width: 25,height: Int(-value * 0.01))
            print(x)
            
            context?.addRect(rectangle)
            
            context?.strokePath()
            
            context?.setFillColor(UIColor.red.cgColor)
            context?.fill(rectangle)
            
            x += 50
        }
    }
    
}
