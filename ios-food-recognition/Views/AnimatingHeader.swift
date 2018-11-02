//
//  AnimatingHeader.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 26.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//
import UIKit

class AnimatedHeaderView: UIView {
    
    var imageView: UIImageView!
    var colorView: UIView!
    var bgColor = UIColor(red: 255/255, green: 55/255, blue: 95/255, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        // Header view
        self.backgroundColor = UIColor.clear
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        colorView = UIView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(colorView)
        
        let constraints: [NSLayoutConstraint] = [
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            colorView.topAnchor.constraint(equalTo: self.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ]
        NSLayoutConstraint.activate(constraints)
        
        imageView.contentMode = .scaleAspectFill
        
        colorView.backgroundColor = bgColor
        colorView.alpha = 0.0
        
    }
    
    func decrementColorAlpha(with offset: CGFloat) {
        if self.colorView.alpha <= 1 {
            let alphaOffset = (offset/500)/85
            self.colorView.alpha = alphaOffset
        }
    }
    
    func incrementColorAlpha(with offset: CGFloat) {
        if self.colorView.alpha >= 0.6 {
            let alphaOffset = (offset/200)/85
            self.colorView.alpha -= alphaOffset
        }
    }
    
}
