//
//  HorizontalBarChart.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 31.10.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class HorizontalBar: UIView {

    // MARK: - Properties
    
    var progressValue: Double!
    var goalValue: Double!
    var progressPercentage: CGFloat {
        return CGFloat(progressValue) / CGFloat(goalValue)
    }
    var animationDuration: CFTimeInterval!
    var barWidth: CGFloat!
    var barColor: CGColor!
    var bgBarColor = UIColor.lightGray.cgColor
    
    private let bgLayer = CAShapeLayer()
    private let fgLayer = CAShapeLayer()
    
    // MARK: - Init
    
    init(frame: CGRect, progress: Double, goal: Double, animationDuration: CFTimeInterval? = 1.0, barWidth: CGFloat? = 15.0, barColor: CGColor? = UIColor.red.cgColor) {
        super.init(frame: frame)
        self.progressValue = progress
        self.goalValue = goal
        self.animationDuration = animationDuration
        self.barWidth = barWidth
        self.barColor = barColor
        
        setupViews()
        animateProgress()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupViews() {
        let fgPath = UIBezierPath()
        fgPath.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
        fgPath.addLine(to: CGPoint(x: bounds.maxX * progressPercentage, y: bounds.midY))
        
        fgLayer.path = fgPath.cgPath
        fgLayer.lineWidth = barWidth
        fgLayer.strokeColor = barColor
        fgLayer.lineCap = CAShapeLayerLineCap.round
        
        let bgPath = UIBezierPath()
        bgPath.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
        bgPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        
        bgLayer.path = bgPath.cgPath
        bgLayer.lineWidth = barWidth
        bgLayer.strokeColor = bgBarColor
        bgLayer.lineCap = CAShapeLayerLineCap.round
        
        layer.addSublayer(bgLayer)
        layer.addSublayer(fgLayer)
    }
    
    private func animateProgress() {
        let activityAnimation = CABasicAnimation(keyPath: "strokeEnd")
        activityAnimation.fromValue = 0.0
        activityAnimation.toValue = 1.0
        activityAnimation.duration = animationDuration
        activityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        fgLayer.add(activityAnimation, forKey: nil)
        
    }
    
}
