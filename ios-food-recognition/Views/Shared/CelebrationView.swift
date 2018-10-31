//
//  CelebrationView.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 30.10.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class CelebrationView: UIView {

    // MARK: - Properties
    
    var title: String!
    var message: String!
    
    private var textColor = UIColor.black
    
    init(frame: CGRect, title: String, message: String) {
        super.init(frame: frame)
        self.title = title
        self.message = message
        
        setupMessageView()
        setupEmitterView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupMessageView() {
        layer.backgroundColor = UIColor.red.cgColor
        
        let messageView = UIView()
        let height = bounds.height / 2
        messageView.frame = CGRect(x: bounds.midX / 2, y: bounds.maxY + height, width: bounds.width - 60, height: bounds.height / 5)
        messageView.backgroundColor = .white
        messageView.clipsToBounds = true
        messageView.layer.cornerRadius = 20.0
        messageView.layer.shadowColor = UIColor.gray.cgColor
        messageView.dropShadow(color: .black, offSet: CGSize(width: 15, height: 15), radius: 20.0)
        messageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        let titleLabel = UILabel()
        titleLabel.text = "Congratulations!!!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = textColor
        
        let messageLabel = UILabel()
        messageLabel.text = "You have achieved all your goals yesterday. Keep it up!"
        messageLabel.numberOfLines = 30
        messageLabel.font = UIFont.systemFont(ofSize: 20.0)
        messageLabel.textAlignment = .center
        messageLabel.textColor = textColor
        
        addSubview(messageView)
        messageView.addSubview(titleLabel)
        messageView.addSubview(messageLabel)
        
        titleLabel.anchor(top: messageView.topAnchor, left: messageView.leftAnchor, bottom: nil, right: messageView.rightAnchor, paddingTop: 20.0, paddingLeft: 20, paddingRight: 20, paddingBottom: 20.0, width: 0.0, height: 25.0)
        messageLabel.anchor(top: titleLabel.bottomAnchor, left: messageView.leftAnchor, bottom: messageView.bottomAnchor, right: messageView.rightAnchor, paddingTop: 20.0, paddingLeft: 20, paddingRight: 20, paddingBottom: 0.0, width: 0.0, height: 0.0)
        
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 4.0, options: [.curveEaseIn], animations: {
            messageView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            messageView.transform = .identity
        }, completion: nil)
    }
    
    private func setupEmitterView() {
        let showerHead = UIImageView(image: UIImage(named: "showerHead")!.withRenderingMode(.alwaysTemplate))
        showerHead.tintColor = .white
        showerHead.frame = CGRect(x: bounds.midX / 2, y: -100.0, width: bounds.width / 2, height: 100)
        addSubview(showerHead)
        
        UIView.animate(withDuration: 0.7, delay: 3.0, animations: {
            showerHead.frame = CGRect(x: self.bounds.midX / 2, y: 20.0, width: self.bounds.width / 2, height: 100)
        }) { (_) in
            let rect = CGRect(x: 0.0, y: 130.0, width: self.bounds.width, height: 50.0)
            let emitter = CAEmitterLayer()
            emitter.frame = rect
            emitter.emitterShape = CAEmitterLayerEmitterShape.point
            emitter.emitterPosition = CGPoint(x: rect.width/2, y: rect.height/2)
            emitter.emitterSize = rect.size
            self.layer.addSublayer(emitter)
            
            let emitterCell = CAEmitterCell()
            emitterCell.contents = UIImage(named: "chickenIcon")?.cgImage
            emitterCell.birthRate = 25
            emitterCell.lifetime = 5
            emitterCell.yAcceleration = 100.0
            emitterCell.xAcceleration = 10.0
            emitterCell.zAcceleration = 10.0
            emitterCell.spin = 5.0
            emitterCell.velocity = 350.0
            //emitterCell.velocityRange = 200.0
            emitterCell.emissionLongitude = .pi * 0.5
            emitterCell.emissionRange = .pi * 0.5
            emitterCell.scale = 0.5
            //emitterCell.scaleRange = 0.5
            emitter.emitterCells = [emitterCell]
        }
    }
}
