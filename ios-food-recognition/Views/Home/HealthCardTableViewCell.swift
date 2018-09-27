//
//  HealthCardTableViewCell.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 26.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class HealthCardTableViewCell: UITableViewCell {

    
    // MARK: Properties
    var healthCard: HealthCard?
    
    private var titleTextLabel: UILabel!
    private var bodyView: UIView!
    
    private var margins: CGFloat = 20.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        setupHeader()
        setupBody()
    }
    
    private func setupHeader() {
        titleTextLabel = UILabel()
        
        titleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(titleTextLabel)
        
        let constraints: [NSLayoutConstraint] = [
            titleTextLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margins),
            titleTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margins),
            titleTextLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: margins),
        ]
        NSLayoutConstraint.activate(constraints)
        
        titleTextLabel.text = "Vitamin Breakdown"
        titleTextLabel.numberOfLines = 1
        titleTextLabel.textAlignment = .left
        titleTextLabel.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    private func setupBody() {
        bodyView = UIView()
        let bodyStackView = UIStackView()
        
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        bodyStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(bodyView)
        bodyView.addSubview(bodyStackView)
        
        var constraints: [NSLayoutConstraint] = [
            bodyView.topAnchor.constraint(equalTo: titleTextLabel.bottomAnchor, constant: margins),
            bodyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margins),
            bodyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margins),
            bodyView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margins),
            bodyStackView.topAnchor.constraint(equalTo: bodyView.topAnchor),
            bodyStackView.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor),
            bodyStackView.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor),
            bodyStackView.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor),
            ]
        
        if let healthCard = healthCard {
            for item in healthCard.items {
                let itemStackView = UIStackView()
                let itemTitle = UILabel()
                let itemProgress = UIProgressView(progressViewStyle: .default)
                let transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
                itemProgress.transform = transform
                
                itemStackView.translatesAutoresizingMaskIntoConstraints = false
                itemTitle.translatesAutoresizingMaskIntoConstraints = false
                itemProgress.translatesAutoresizingMaskIntoConstraints = false

                itemStackView.addArrangedSubview(itemTitle)
                itemStackView.addArrangedSubview(itemProgress)
                bodyStackView.addArrangedSubview(itemStackView)
            
                itemStackView.leadingAnchor.constraint(equalTo: bodyStackView.leadingAnchor).isActive = true
                itemStackView.trailingAnchor.constraint(equalTo: bodyStackView.trailingAnchor).isActive = true

                itemStackView.axis = .horizontal
                itemStackView.alignment = .center
                itemStackView.setCustomSpacing(12.0, after: itemTitle)

                itemTitle.text = item.title
                itemProgress.progress = 0.0
                itemProgress.setProgress(0.6, animated: true)

            }
        }
        
        NSLayoutConstraint.activate(constraints)
    
        
        
        bodyStackView.axis = .vertical
        bodyStackView.distribution = .equalSpacing
        bodyStackView.alignment = .center
    }

}
