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
    var bgColor = UIColor(red: 235/255, green: 96/255, blue: 91/255, alpha: 1)
    var titleLabel = UILabel()
    
    init(frame: CGRect, title: String) {
        self.titleLabel.text = title.uppercased()
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        // The general pattern when using autolayout programmatically with any view is to first initialize the view, set its translatesAutoresizingMaskIntoConstraints property to false, add it to the view, set the constraints, activate the constraints, and then set all its properties, fonts, text, image etc.
        
        // Header view
        self.backgroundColor = UIColor.white
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
        
        // Aspect fill will scale the image with the view's frame (when we pull it down it will have a zoom-like effect)
        imageView.contentMode = .scaleAspectFill
        
        colorView.backgroundColor = bgColor
        colorView.alpha = 0.0
        
        // Title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        let titlesConstraints: [NSLayoutConstraint] = [
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 28),
            ]
        NSLayoutConstraint.activate(titlesConstraints)
        
        titleLabel.font = UIFont.systemFont(ofSize: 15.0)
        titleLabel.textAlignment = .center
        
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
