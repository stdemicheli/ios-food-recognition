//
//  HorizontalBarChart.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 01.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class HorizontalBarChart: UIView {
    
    // MARK: - Properties
    
    var data: [(String, Double, Double)]!
    var animationDuration: CFTimeInterval!
    var barWidth: CGFloat!
    var barColor: CGColor!
    
    @IBInspectable private var mainStackView = UIStackView()
    
    // MARK: - Init
    
    init(frame: CGRect, data: [(String, Double, Double)], animationDuration: CFTimeInterval? = 1.0, barWidth: CGFloat? = 15.0, barColor: CGColor? = UIColor.red.cgColor) {
        super.init(frame: frame)
        self.data = data
        self.animationDuration = animationDuration
        self.barWidth = barWidth
        self.barColor = barColor
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    
    
    // MARK: - Private

    private func setupViews() {
        mainStackView.frame = bounds
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 20.0
        addSubview(mainStackView)
        
        data.forEach { setupBar(withTitle: $0.0, progress: $0.1, goal: $0.2) }
        
    }
    
    private func setupBar(withTitle title: String, progress: Double, goal: Double) {
        let barStackView = UIStackView()
        
        barStackView.axis = .horizontal
        barStackView.distribution = .fill
        barStackView.alignment = .center
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let frame = CGRect(x: 0, y: 0, width: mainStackView.bounds.width / 1.65, height: 0)
        let bar = HorizontalBar(frame: frame, progress: progress, goal: goal)
        
        barStackView.addArrangedSubview(titleLabel)
        barStackView.addArrangedSubview(bar)
        mainStackView.addArrangedSubview(barStackView)
        
        titleLabel.widthAnchor.constraint(equalTo: barStackView.widthAnchor, multiplier: 0.3).isActive = true
        
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
}
