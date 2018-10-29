//
//  HealthCardTableViewCell.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 26.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import HealthKit

class HealthCardTableViewCell: UITableViewCell {

    
    // MARK: Properties
    var nutrients: [HKQuantityType : Double]? {
        didSet {
            setupViews()
        }
    }
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
        
        titleTextLabel.numberOfLines = 1
        titleTextLabel.textAlignment = .left
        titleTextLabel.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private func setupBody() {
        bodyView = UIView()
        let bodyStackView = UIStackView()
        
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        bodyStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(bodyView)
        bodyView.addSubview(bodyStackView)
        
        let constraints: [NSLayoutConstraint] = [
            bodyView.topAnchor.constraint(equalTo: titleTextLabel.bottomAnchor, constant: margins),
            bodyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margins),
            bodyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margins),
            bodyView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margins),
            bodyStackView.topAnchor.constraint(equalTo: bodyView.topAnchor),
            bodyStackView.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor),
            bodyStackView.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor),
            bodyStackView.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor),
        ]
        
//        if let nutrients = nutrients {
//            let vitamins = filterNutrients(for: nutrients, with: Constants.HealthKit().vitaminTypes)
//
//            titleTextLabel.text = "Vitamin Breakdown"
//            for vitamin in vitamins {
//                let itemStackView = UIStackView()
//                let itemTitle = UILabel()
//                let itemProgress = UIProgressView(progressViewStyle: .default)
//                let transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
//                itemProgress.transform = transform
//
//                itemStackView.translatesAutoresizingMaskIntoConstraints = false
//                itemTitle.translatesAutoresizingMaskIntoConstraints = false
//                itemProgress.translatesAutoresizingMaskIntoConstraints = false
//
//                itemStackView.addArrangedSubview(itemTitle)
//                itemStackView.addArrangedSubview(itemProgress)
//                bodyStackView.addArrangedSubview(itemStackView)
//
//                itemStackView.leadingAnchor.constraint(equalTo: bodyStackView.leadingAnchor).isActive = true
//                itemStackView.trailingAnchor.constraint(equalTo: bodyStackView.trailingAnchor).isActive = true
//                itemTitle.widthAnchor.constraint(equalToConstant: 120).isActive = true
//
//                itemStackView.axis = .horizontal
//                itemStackView.alignment = .center
//                itemStackView.setCustomSpacing(12.0, after: itemTitle)
//
//                switch vitamin.key {
//                case HKObjectType.quantityType(forIdentifier: .dietaryVitaminA)!:
//                    let goal = 0.0009
//                    itemTitle.text = "Vitamin A"
//                    itemProgress.progress = 0.0
//                    itemProgress.setProgress(Float(vitamin.value / goal), animated: true)
//                case HKObjectType.quantityType(forIdentifier: .dietaryVitaminC)!:
//                    let goal = 0.09
//                    itemTitle.text = "Vitamin C"
//                    itemProgress.progress = 0.0
//                    itemProgress.setProgress(Float(vitamin.value / goal), animated: true)
//                case HKObjectType.quantityType(forIdentifier: .dietaryVitaminD)!:
//                    let goal = 0.6
//                    itemTitle.text = "Vitamin D"
//                    itemProgress.progress = 0.0
//                    itemProgress.setProgress(Float(vitamin.value / goal), animated: true)
//                case HKObjectType.quantityType(forIdentifier: .dietaryFolate)!:
//                    let goal = 0.0004
//                    itemTitle.text = "Folate"
//                    itemProgress.progress = 0.0
//                    itemProgress.setProgress(Float(vitamin.value / goal), animated: true)
//                default:
//                    continue
//                }
//            }
//        }
        
        NSLayoutConstraint.activate(constraints)
        
        bodyStackView.axis = .vertical
        bodyStackView.distribution = .equalSpacing
        bodyStackView.alignment = .center
    }
    
    private func filterNutrients(for nutrients: [HKQuantityType : Double], with types: Set<HKQuantityType>) -> [HKQuantityType : Double] {
        return nutrients.filter { (key, value) -> Bool in
            for type in types {
                if key == type {
                    return true
                }
            }
            return false
        }
    }

}
