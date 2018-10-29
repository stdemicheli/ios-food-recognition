//
//  ActivityIndicator.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 29.10.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class ActivityIndicator: UIView, CAAnimationDelegate {

    // MARK: - Properties
    
    var timeout: CFTimeInterval = 30.0
    var animationDuration: CFTimeInterval = 1.5
    var opacity: CGFloat = 0.9
    var lineWidth: CGFloat = 15.0
    
    private let activityShapeLayer = CAShapeLayer()
    private var activityFrame: CGRect!
    private let activityRadius: CGFloat = 100.0
    private let iconLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupActivityIndicator()
        beginAnimation()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func beginAnimation() {
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -0.75
        strokeStartAnimation.toValue = 1.0
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = animationDuration
        strokeAnimationGroup.repeatDuration = timeout
        strokeAnimationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        strokeAnimationGroup.delegate = self
        strokeAnimationGroup.setValue("activityIndicator", forKey: "name")
        activityShapeLayer.add(strokeAnimationGroup, forKey: "layer")
        
        let iconAnimation = CAKeyframeAnimation(keyPath: "position")
        iconAnimation.path = activityShapeLayer.path
        iconAnimation.calculationMode = .paced
        
        let iconRotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        iconRotationAnimation.fromValue = 0
        iconRotationAnimation.toValue = 2.0 * .pi
        
        let iconAnimationGroup = CAAnimationGroup()
        iconAnimationGroup.duration = animationDuration
        iconAnimationGroup.repeatDuration = timeout
        iconAnimationGroup.delegate = self
        iconAnimationGroup.setValue("icon", forKey: "name")
        iconAnimationGroup.animations = [iconAnimation, iconRotationAnimation]
        iconLayer.add(iconAnimationGroup, forKey: "layer")
        
    }
    
    func endAnimation() {
        layer.removeAllAnimations()
        activityShapeLayer.removeFromSuperlayer()
        iconLayer.removeFromSuperlayer()
        self.removeFromSuperview()
    }
    
    // MARK: - CAAniamtionDelegate
    
    func animationDidStart(_ anim: CAAnimation) {
        guard let name = anim.value(forKey: "name") as? String else { return }
        print("animationstarted: \(name)")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let name = anim.value(forKey: "name") as? String else { return }
        print("animationfinished: \(name)")
        
        if name == "activityIndicator" {
            endAnimation()
        }
        
    }
    
    // MARK: - Private
    
    private func setupViews() {
        backgroundColor = UIColor(white: 0.9, alpha: opacity)
    }
    
    private func setupActivityIndicator() {
        activityFrame = CGRect(x: bounds.midX - activityRadius,
                             y: bounds.midY - activityRadius,
                             width: activityRadius * 2,
                             height: activityRadius * 2)
        
        activityShapeLayer.strokeColor = UIColor.gray.cgColor
        activityShapeLayer.fillColor = UIColor.clear.cgColor
        activityShapeLayer.lineWidth = lineWidth
        activityShapeLayer.path = UIBezierPath(ovalIn: activityFrame).cgPath
        layer.addSublayer(activityShapeLayer)
        
        
        let icon = UIImage(named: "chickenIcon")!
        iconLayer.contents = icon.cgImage
        iconLayer.bounds = CGRect(x: 0.0, y: 0.0,
                                  width: icon.size.width,
                                  height: icon.size.height)
        
        iconLayer.position = CGPoint(x: bounds.midX - activityRadius * 2,
                                     y: bounds.midY - activityRadius)
        layer.addSublayer(iconLayer)
    }

}
