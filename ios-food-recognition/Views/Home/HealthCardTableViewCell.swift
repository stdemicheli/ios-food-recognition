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
    var nutrients: [HKSampleType : Double]? {
        didSet {
            setupViews()
        }
    }
    
    var title: String?
    
    var goals: [(String, Double, Double)]? {
        didSet {
            setupViews()
        }
    }
    
    private var titleTextLabel: UILabel!
    private var bodyView: UIView!
    private var horizontalBarChart: HorizontalBarChart!
    
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
        bodyView = UIView()
        
        titleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleTextLabel)
        addSubview(bodyView)
        
        let constraints: [NSLayoutConstraint] = [
            titleTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: margins),
            titleTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margins),
            titleTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: margins),
            bodyView.topAnchor.constraint(equalTo: titleTextLabel.topAnchor, constant: margins * 2),
            bodyView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margins),
            bodyView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: margins),
            bodyView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: margins),
        ]
        NSLayoutConstraint.activate(constraints)
        
        titleTextLabel.numberOfLines = 1
        titleTextLabel.textAlignment = .left
        titleTextLabel.font = UIFont.boldSystemFont(ofSize: 20)
        guard let title = title else { return }
        titleTextLabel.text = title
    }
    
    private func setupBody() {
        guard let goals = goals else { return }
        
        let frame = CGRect(x: 0, y: 0, width: bounds.width, height: bodyView.bounds.height)
        horizontalBarChart = HorizontalBarChart(frame: frame, data: goals)
        horizontalBarChart.translatesAutoresizingMaskIntoConstraints = false
        bodyView.addSubview(horizontalBarChart)
        
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
