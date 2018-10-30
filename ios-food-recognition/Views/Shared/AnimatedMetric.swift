//
//  AnimatedMetric.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 30.10.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class AnimatedMetric: UIView {
    
    // MARK: - Properties

    var metric: Double = 0.0
    var title: String = ""
    var fontSize: CGFloat = 18.0
    var textColor = UIColor.white
    var imageView = UIImageView()
    var imageColor = UIColor.orange
    var animationDuration: Double = 0.0
    
    private var metricLabel = UILabel()
    private var metricTitle = UILabel()
    private var metricStartValue = 0.0
    private let animationStartDate = Date()
    
    init(frame: CGRect, metric: Double, title: String, image: UIImage?, animationDuration: Double = 0.0) {
        super.init(frame: frame)
        self.metric = metric
        self.title = title
        self.imageView.image = image
        self.animationDuration = animationDuration
        
        setupViews()
        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        metricLabel.translatesAutoresizingMaskIntoConstraints = false
        metricTitle.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        if imageView.image != nil {
            stackView.addArrangedSubview(imageView)
        }
        stackView.addArrangedSubview(metricLabel)
        stackView.addArrangedSubview(metricTitle)
        
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: frame.width, height: frame.height)
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        
        imageView.tintColor = imageColor
        
        metricLabel.textAlignment = .center
        metricLabel.textColor = textColor
        metricLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        
        metricTitle.text = title
        metricTitle.textAlignment = .center
        metricTitle.textColor = textColor
        metricTitle.font = UIFont.systemFont(ofSize: fontSize - 4.0)
        metricTitle.numberOfLines = 2
        
    }
    
    private func animate() {
        let imageAnimation = CABasicAnimation(keyPath: "transform.scale")
        imageAnimation.fromValue = 1.3
        imageAnimation.toValue = 1
        imageAnimation.duration = 0.3
        imageAnimation.repeatDuration = animationDuration
        imageView.layer.add(imageAnimation, forKey: nil)
        
        let displayLink = CADisplayLink(target: self, selector: #selector(handleValueUpdate))
        displayLink.add(to: .main, forMode: .default)
    }
    
    @objc private func handleValueUpdate() {
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        if elapsedTime > animationDuration {
            metricLabel.text = String(format: "%.0f", metric)
        } else {
            let percentage = elapsedTime / animationDuration
            let value = metricStartValue + percentage * (metric - metricStartValue)
            metricLabel.text = String(format: "%.0f", value)
        }
    }
    
}
