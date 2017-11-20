//
//  ViewController.swift
//  Clock
//
//  Created by Justyna Rafalska on 18.11.2017.
//  Copyright © 2017 jrafa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var pointCenterX: CGFloat = 0.0
    private var pointCenterY: CGFloat = 0.0
    
    private var radiusHour: CGFloat = 0.0
    private var radiusMinute: CGFloat = 0.0
    private var radiusSecond: CGFloat = 0.0
    
    private let shapeLayerSecond = CAShapeLayer()
    private let shapeLayerMinute = CAShapeLayer()
    private let shapeLayerHour = CAShapeLayer()

    private var timer = Timer()
    
    private let clockColor = UIColor(red: 0.45, green: 0.00, blue: 0.85, alpha: 1.0)
    private let secondHandColor = UIColor(red: 0.98, green: 0.75, blue: 0.05, alpha: 1.0)
    private let minuteHandColor = UIColor(red: 0.00, green: 0.73, blue: 0.95, alpha: 1.0)
    private let hourHandColor = UIColor(red: 0.98, green: 0.20, blue: 0.05, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pointCenterX = self.view.frame.width / 2.0
        pointCenterY = self.view.frame.height / 2.0
        
        radiusHour = pointCenterY - self.view.frame.width * 3.0 / 5.0 - 25.0
        radiusMinute = pointCenterY - self.view.frame.width * 3.0 / 5.0
        radiusSecond = pointCenterY - self.view.frame.width * 3.0 / 5.0 + 25.0
        
        drawCircle()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(moveHand),
                                     userInfo: nil,
                                     repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setClock() -> Array<Double> {
        let date = NSDate()
        let calendar = NSCalendar.current
        
        let hour = Double(calendar.component(Calendar.Component.hour, from: date as Date))
        let minute = Double(calendar.component(Calendar.Component.minute, from: date as Date))
        let second = Double(calendar.component(Calendar.Component.second, from: date as Date))
        let nanosecond = Double(calendar.component(Calendar.Component.nanosecond, from: date as Date))
        
        return [hour + minute / 60.0, minute + second / 60.0, second + nanosecond / pow(10, 9)]
    }
    
    @objc func moveHand() {
        let timeClock = setClock()
        let moveAngleStart = 90.0
        
        drawLine(shapeLayer: shapeLayerSecond,
                 name: "second",
                 color: secondHandColor.cgColor,
                 angle: CGFloat(timeClock[2] * 6.0 - moveAngleStart),
                 radius: radiusSecond)
        
        drawLine(shapeLayer: shapeLayerMinute,
                 name: "minute",
                 color: minuteHandColor.cgColor,
                 angle: CGFloat(timeClock[1] * 6.0 - moveAngleStart),
                 radius: radiusMinute)
        
        drawLine(shapeLayer: shapeLayerHour,
                 name: "hour",
                 color: hourHandColor.cgColor,
                 angle: CGFloat(timeClock[0] * 30.0 - moveAngleStart),
                 radius: radiusHour)
    }
    
    func getSecondPoint(centerPoint: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        return CGPoint(x: Double(centerPoint.x) + cos(Double(angle) * Double.pi / 180.0) * Double(radius),
                       y: Double(centerPoint.y) + sin(Double(angle) * Double.pi / 180.0) * Double(radius))
    }
    
    func drawCircle() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: pointCenterX, y: pointCenterY),
                                      radius: CGFloat(self.view.frame.width * 2.0 / 5.0),
                                      startAngle: CGFloat(0),
                                      endAngle: CGFloat(2 * Double.pi),
                                      clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "circle"
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = clockColor.cgColor
        shapeLayer.lineWidth = 7.0
        
        self.view.layer.addSublayer(shapeLayer)
    }
    
    func drawLine(shapeLayer: CAShapeLayer, name: String, color: CGColor, angle: CGFloat, radius: CGFloat) {
        let point = getSecondPoint(centerPoint: CGPoint(x: pointCenterX, y: pointCenterY),
                                   radius: radius,
                                   angle: angle)
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: pointCenterX, y: pointCenterY))
        linePath.addLine(to: point)
        linePath.close()
        
        let shapeLayer = shapeLayer
        shapeLayer.name = name
        shapeLayer.path = linePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 5.0

        self.view.layer.addSublayer(shapeLayer)
    }

}

