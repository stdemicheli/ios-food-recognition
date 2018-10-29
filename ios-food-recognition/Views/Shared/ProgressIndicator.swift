//
//  ProgressIndicator.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 29.10.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class ProgressIndicator: UIView {
    
    // MARK: - Properties

    var lineWidth: CGFloat = 35.0
    var bgColor = UIColor.gray.cgColor
    var fgColor = UIColor.blue.cgColor
    var progressValue: Double!
    var animationDuration = 1.2
    var fontSize: CGFloat = 24.0
    
    private var metricLabel = UILabel()
    private var descriptionLabel = UILabel()
    private let bgLayer = CAShapeLayer()
    private let fgLayer = CAShapeLayer()
    private let margin: CGFloat = 10
    private var startValue = 0.0
    private let animationStartDate = Date()
    
    // MARK: - Init
    
    init(frame: CGRect, progress: Double) {
        super.init(frame: frame)
        self.progressValue = progress
        setupViews()
        animateProgress()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShapeLayer(bgLayer)
        setupShapeLayer(fgLayer)
    }
    
    // MARK: - Private

    private func setupViews() {
        bgLayer.lineWidth = lineWidth
        bgLayer.fillColor = nil
        bgLayer.strokeColor = bgColor
        bgLayer.strokeEnd = 1.0
        layer.addSublayer(bgLayer)
        
        fgLayer.lineWidth = lineWidth
        fgLayer.fillColor = nil
        fgLayer.strokeColor = fgColor
        fgLayer.strokeEnd = 0.5
        layer.addSublayer(fgLayer)
        
        setupShapeLayer(bgLayer)
        setupShapeLayer(fgLayer)
        
        metricLabel.font = UIFont.systemFont(ofSize: fontSize)
        metricLabel.textColor = UIColor.black
        //metricLabel.text = "0"
        metricLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(metricLabel)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: fontSize)
        descriptionLabel.text = "kCal"
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)
        
        metricLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        metricLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -margin).isActive = true
        
        descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: metricLabel.bottomAnchor, constant: margin * 3).isActive = true
    }
    
    private func animateProgress() {
        let activityAnimation = CABasicAnimation(keyPath: "strokeEnd")
        activityAnimation.fromValue = 0.0
        activityAnimation.toValue = 0.5
        activityAnimation.duration = animationDuration
        activityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        fgLayer.add(activityAnimation, forKey: nil)
    
        // Make the count up from startValue to final progressValue visible to the user
        let displayLink = CADisplayLink(target: self, selector: #selector(handleValueUpdate))
        displayLink.add(to: .main, forMode: .default)
    }
    
    @objc private func handleValueUpdate() {
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        if elapsedTime > animationDuration {
            metricLabel.text = String(format: "%.0f", progressValue)
        } else {
            let percentage = elapsedTime / animationDuration
            let value = startValue + percentage * (progressValue - startValue)
            metricLabel.text = String(format: "%.0f", value)
            print(String(format: "%.0f", value))
        }
    }
    
    private func setupShapeLayer(_ shapeLayer: CAShapeLayer) {
        shapeLayer.frame = self.bounds
        let startAngle = DegreesToRadians(value: 135.0)
        let endAngle = DegreesToRadians(value: 45.0)
        //let center = metricLabel.center
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = self.bounds.width * 0.35
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapeLayer.path = path.cgPath
    }
    
}
