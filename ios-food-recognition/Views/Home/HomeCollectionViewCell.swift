//
//  HomeCollectionViewCell.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 26.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import HealthKit

protocol HomeCollectionViewCellDelegate {
    func next()
    func previous()
    // func goToCell(with id: String)
}

class HomeCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: - Properties (public)
    
    let hkController = HealthKitController()
    
    var nutrients: [HKQuantityType : Double]? {
        didSet {
            setupViews()
        }
    }
    var date: Date? {
        didSet {
            setupHeader()
        }
    }
    
    var healthCards: [HealthCard]? {
        didSet {
            setupTableView()
        }
    }
    var delegate: HomeCollectionViewCellDelegate?
    var calories: Double? {
        return nutrients?[HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!]
    }
    var protein: Double? {
        return nutrients?[HKObjectType.quantityType(forIdentifier: .dietaryProtein)!]
    }
    var carbs: Double? {
        return nutrients?[HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates)!]
    }
    var fat: Double? {
        return nutrients?[HKObjectType.quantityType(forIdentifier: .dietaryFatTotal)!]
    }
    
    // MARK: - Properties (private)
    
    var tableView: UITableView!
    private var expandedCellAtIndexPath: IndexPath?
    private var tableViewCellHeight = UIScreen.main.bounds.height / 3
    
    private let reuseId = "HealthCardCell"
    var headerView: AnimatedHeaderView!
    private var headerViewExpandedHeight = UIScreen.main.bounds.size.height / 2.4
    private var headerViewCollapsedHeight: CGFloat = 80.0
    private var headerHeightConstraint: NSLayoutConstraint!
    
    private var prevButton: UIButton!
    private var headerTitle: UILabel!
    private var nextButton: UIButton!
    
    private var mainStackView: UIStackView!
    private var progressIndicator: ProgressIndicator!
    
    private var btmStackView: UIStackView!
    private var btmLeftMetric: UILabel!
    private var btmMidMetric: UILabel!
    private var btmRightMetric: UILabel!
    private var btmLeftMetricTitle: UILabel!
    private var btmMidMetricTitle: UILabel!
    private var btmRightMetricTitle: UILabel!
    
    private var animationDuration = 1.2
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - HomeCollectionViewCellDelegate
    
    @objc func previousCell() {
        delegate?.previous()
    }
    
    @objc func nextCell() {
        delegate?.next()
    }
    
    // MARK: - Views
    
    private func setupViews() {
        setupHeader()
        setupTableView()
    }
    
    private func setupHeader() {
        headerView = AnimatedHeaderView(frame: CGRect.zero)
        
        let topStackView = UIStackView()
        prevButton = UIButton(type: .system)
        headerTitle = UILabel()
        nextButton = UIButton(type: .system)
        
        mainStackView = UIStackView()
        progressIndicator = ProgressIndicator(frame: CGRect.zero, progress: 1234, animationDuration: animationDuration)
        let caloriesConsumedView = AnimatedMetric(frame: CGRect.zero, metric: 600, title: "Calories Consumed", image: UIImage(named: "flatwareIcon")!.withRenderingMode(.alwaysTemplate), animationDuration: animationDuration)
        let caloriesBurnedView = AnimatedMetric(frame: CGRect.zero, metric: 600, title: "Calories Burned", image: UIImage(named: "fire")!.withRenderingMode(.alwaysTemplate), animationDuration: animationDuration)
//        if let calories = calories {
//            progressIndicator = ProgressIndicator(frame: CGRect.zero, progress: calories)
//        } else {
//            progressIndicator = ProgressIndicator(frame: CGRect.zero, progress: 1234)
//        }
        
        btmStackView = UIStackView()
        let btmLeftStackView = UIStackView()
        let btmMidStackView = UIStackView()
        let btmRightStackView = UIStackView()
        btmLeftMetric = UILabel()
        btmMidMetric = UILabel()
        btmRightMetric = UILabel()
        btmLeftMetricTitle = UILabel()
        btmMidMetricTitle = UILabel()
        btmRightMetricTitle = UILabel()
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        caloriesConsumedView.translatesAutoresizingMaskIntoConstraints = false
        caloriesBurnedView.translatesAutoresizingMaskIntoConstraints = false
        
        btmStackView.translatesAutoresizingMaskIntoConstraints = false
        btmLeftStackView.translatesAutoresizingMaskIntoConstraints = false
        btmMidStackView.translatesAutoresizingMaskIntoConstraints = false
        btmRightStackView.translatesAutoresizingMaskIntoConstraints = false
        btmLeftMetric.translatesAutoresizingMaskIntoConstraints = false
        btmMidMetric.translatesAutoresizingMaskIntoConstraints = false
        btmRightMetric.translatesAutoresizingMaskIntoConstraints = false
        btmLeftMetricTitle.translatesAutoresizingMaskIntoConstraints = false
        btmMidMetricTitle.translatesAutoresizingMaskIntoConstraints = false
        btmRightMetricTitle.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(headerView)
        
        headerView.addSubview(topStackView)
        topStackView.addArrangedSubview(prevButton)
        topStackView.addArrangedSubview(headerTitle)
        topStackView.addArrangedSubview(nextButton)
        
        headerView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(caloriesConsumedView)
        mainStackView.addArrangedSubview(progressIndicator)
        mainStackView.addArrangedSubview(caloriesBurnedView)
        
        headerView.addSubview(btmStackView)
        btmStackView.addArrangedSubview(btmLeftStackView)
        btmStackView.addArrangedSubview(btmMidStackView)
        btmStackView.addArrangedSubview(btmRightStackView)
        btmLeftStackView.addArrangedSubview(btmLeftMetric)
        btmLeftStackView.addArrangedSubview(btmLeftMetricTitle)
        btmMidStackView.addArrangedSubview(btmMidMetric)
        btmMidStackView.addArrangedSubview(btmMidMetricTitle)
        btmRightStackView.addArrangedSubview(btmRightMetric)
        btmRightStackView.addArrangedSubview(btmRightMetricTitle)
        
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerViewExpandedHeight)
        headerHeightConstraint.isActive = true
        
        let constraints: [NSLayoutConstraint] = [
            headerView.topAnchor.constraint(equalTo: self.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topStackView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 30),
            topStackView.heightAnchor.constraint(equalToConstant: headerViewCollapsedHeight),
            topStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            topStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            btmStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
            btmStackView.heightAnchor.constraint(equalTo: progressIndicator.heightAnchor, multiplier: 0.2),
            btmStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            btmStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 30),
            mainStackView.bottomAnchor.constraint(equalTo: btmStackView.topAnchor, constant: -20),
            mainStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            progressIndicator.centerXAnchor.constraint(equalTo: mainStackView.centerXAnchor),
            progressIndicator.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.6)
            ]
        NSLayoutConstraint.activate(constraints)
        
        headerView.backgroundColor = .red
        
        topStackView.axis = .horizontal
        topStackView.distribution = .equalSpacing
        topStackView.alignment = .center
        
        headerTitle.numberOfLines = 1
        headerTitle.textAlignment = .center
        if let date = self.date {
            headerTitle.text = formatDate(for: date)
        }
        headerTitle.textColor = .white
        headerTitle.font = UIFont.boldSystemFont(ofSize: 17)
        
        caloriesConsumedView.textColor = .white
        caloriesBurnedView.textColor = .white
        
        prevButton.setImage(UIImage(named: "backArrow")!, for: .normal)
        prevButton.tintColor = UIColor.white
        prevButton.addTarget(self, action: #selector(previousCell), for: .touchUpInside)
        
        nextButton.setImage(UIImage(named: "forwardArrow")!, for: .normal)
        nextButton.tintColor = UIColor.white
        nextButton.addTarget(self, action: #selector(nextCell), for: .touchUpInside)
        
        mainStackView.axis = .horizontal
        mainStackView.distribution = .equalSpacing
        mainStackView.alignment = .center
        
        btmStackView.axis = .horizontal
        btmStackView.distribution = .equalSpacing
        btmStackView.alignment = .center
        
        btmLeftStackView.axis = .vertical
        btmLeftStackView.distribution = .fill
        btmLeftStackView.alignment = .center
        
        btmMidStackView.axis = .vertical
        btmMidStackView.distribution = .fill
        btmMidStackView.alignment = .center
        
        btmRightStackView.axis = .vertical
        btmRightStackView.distribution = .fill
        btmRightStackView.alignment = .center
        
        btmLeftMetric.numberOfLines = 1
        btmLeftMetric.textAlignment = .center
        btmLeftMetric.textColor = .white
        btmLeftMetric.font = UIFont.boldSystemFont(ofSize: 17)
        
        btmMidMetric.numberOfLines = 1
        btmMidMetric.textAlignment = .center
        btmMidMetric.textColor = .white
        btmMidMetric.font = UIFont.boldSystemFont(ofSize: 17)
        
        btmRightMetric.numberOfLines = 1
        btmRightMetric.textAlignment = .center
        btmRightMetric.textColor = .white
        btmRightMetric.font = UIFont.boldSystemFont(ofSize: 17)
        
        btmLeftMetricTitle.numberOfLines = 1
        btmLeftMetricTitle.textAlignment = .center
        btmLeftMetricTitle.text = "Carbs"
        btmLeftMetricTitle.textColor = .white
        btmLeftMetricTitle.font = UIFont.boldSystemFont(ofSize: 17)
        btmMidMetricTitle.numberOfLines = 1
        btmMidMetricTitle.textAlignment = .center
        btmMidMetricTitle.text = "Protein"
        btmMidMetricTitle.textColor = .white
        btmMidMetricTitle.font = UIFont.boldSystemFont(ofSize: 17)
        btmRightMetricTitle.numberOfLines = 1
        btmRightMetricTitle.textAlignment = .center
        btmRightMetricTitle.text = "Fat"
        btmRightMetricTitle.textColor = .white
        btmRightMetricTitle.font = UIFont.boldSystemFont(ofSize: 17)
        
        guard let calories = self.calories,
            let protein = self.protein,
            let carbs = self.carbs,
            let fat = self.fat else { return }
        
        let totalCaloriesinGrams = protein + carbs + fat
        
        btmLeftMetric.text = totalCaloriesinGrams != 0 ? "\(String(format: "%.0f%", (carbs / totalCaloriesinGrams) * 100))%" : "0%"
        btmMidMetric.text =  totalCaloriesinGrams != 0 ? "\(String(format: "%.0f%", (protein / totalCaloriesinGrams) * 100))%" : "0%"
        btmRightMetric.text =  totalCaloriesinGrams != 0 ? "\(String(format: "%.0f%", (fat / totalCaloriesinGrams) * 100))%" : "0%"
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        
        let constraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ]
        
        NSLayoutConstraint.activate(constraints)
        
        tableView.register(HealthCardTableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func formatDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
    
    
}

extension HomeCollectionViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 { // Move header down
            self.headerHeightConstraint.constant += abs(scrollView.contentOffset.y)
            headerView.incrementColorAlpha(with: self.headerHeightConstraint.constant)
            let alpha = headerHeightConstraint.constant / (headerViewExpandedHeight - headerViewCollapsedHeight)
            mainStackView.alpha = alpha
            btmStackView.alpha = alpha
        } else if scrollView.contentOffset.y > 0 && self.headerHeightConstraint.constant >= headerViewCollapsedHeight { // Move header up
            // We don't want the header to move up too quickly so we divide the y-offset by 100
            self.headerHeightConstraint.constant -= scrollView.contentOffset.y / 100
            headerView.decrementColorAlpha(with: scrollView.contentOffset.y)
            let alpha =  headerHeightConstraint.constant / (headerViewExpandedHeight - headerViewCollapsedHeight) - 0.5
            mainStackView.alpha = alpha
            btmStackView.alpha = alpha
            
            progressIndicator.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: headerHeightConstraint.constant / (headerViewExpandedHeight - headerViewCollapsedHeight))
            if self.headerHeightConstraint.constant < headerViewCollapsedHeight {
                self.headerHeightConstraint.constant = headerViewCollapsedHeight
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.headerHeightConstraint.constant > headerViewExpandedHeight {
            animateHeader()
        }
    }
    
    // Gets called when the scroll comes to a halt
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.headerHeightConstraint.constant > headerViewExpandedHeight {
            animateHeader()
        }
    }
    
    func animateHeader() {
        // Set and animate the height constraint back to 150
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.headerHeightConstraint.constant = self.headerViewExpandedHeight
            self.layoutIfNeeded()
        }, completion: nil)
        self.layoutSubviews()
    }
    
}

extension HomeCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .gray
        view.alpha = 0.3
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! HealthCardTableViewCell
        
        cell.selectionStyle = .none
        if let nutrients = self.nutrients {
            cell.nutrients = nutrients
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == expandedCellAtIndexPath {
            return tableViewCellHeight * 2.0
        }
        
        return tableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        expandedCellAtIndexPath = expandedCellAtIndexPath == indexPath ? nil : indexPath
        tableView.beginUpdates()
        tableView.endUpdates()
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

