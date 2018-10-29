//
//  ActivityIndicatorViewController.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 29.10.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class ActivityIndicatorViewController: UIViewController, CAAnimationDelegate {
    
    // MARK: - Properties
    var animating = false
    var timeout: CFTimeInterval = 30.0
    var animationDuration: CFTimeInterval = 1.5
    var opacity: CGFloat = 0.9
    var lineWidth: CGFloat = 15.0
    
    private let circleShapeLayer = CAShapeLayer()
    private var circleFrame: CGRect!
    private let circleRadius: CGFloat = 100.0
    private let iconLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupActivityIndicator()
        beginAnimation()
    }
    
    // MARK: - Public
    
    func beginAnimation() {
        animating = true
        
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
        circleShapeLayer.add(strokeAnimationGroup, forKey: "layer")
        
        let iconAnimation = CAKeyframeAnimation(keyPath: "position")
        iconAnimation.path = circleShapeLayer.path
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
        view.layer.removeAllAnimations()
        circleShapeLayer.removeFromSuperlayer()
        iconLayer.removeFromSuperlayer()
        navigationController?.popViewController(animated: true)
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
        view.alpha = opacity
    }
    
    private func setupActivityIndicator() {
        circleFrame = CGRect(x: view.bounds.midX - circleRadius,
                             y: view.bounds.midY - circleRadius,
                             width: circleRadius * 2,
                             height: circleRadius * 2)
        
        circleShapeLayer.strokeColor = UIColor.gray.cgColor
        circleShapeLayer.fillColor = UIColor.clear.cgColor
        circleShapeLayer.lineWidth = lineWidth
        circleShapeLayer.path = UIBezierPath(ovalIn: circleFrame).cgPath
        view.layer.addSublayer(circleShapeLayer)
        
        
        let icon = UIImage(named: "chickenIcon")!
        iconLayer.contents = icon.cgImage
        iconLayer.bounds = CGRect(x: 0.0, y: 0.0,
                                  width: icon.size.width,
                                  height: icon.size.height)
        
        iconLayer.position = CGPoint(x: view.bounds.midX - circleRadius * 2,
                                     y: view.bounds.midY - circleRadius)
        view.layer.addSublayer(iconLayer)
    }

}
