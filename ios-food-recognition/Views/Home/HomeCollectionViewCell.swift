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
    func presentCelebrationView(withTitle title: String)
}

class HomeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties (public)
    
    let hkController = HealthKitController()
    
    var nutrients: [HKSampleType : Double]? {
        didSet {
            setupViews()
        }
    }
    var date: Date? {
        didSet {
            setupHeader()
        }
    }
    var delegate: HomeCollectionViewCellDelegate?
    var caloriesConsumed: Double? {
        return nutrients?[HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!]
    }
    var caloriesBurned: Double? {
        return nutrients?[HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!]
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
    
    var hasShownMessage = false
    
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
    private var caloriesBurnedView: AnimatedMetric!
    private var caloriesConsumedView: AnimatedMetric!
    
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
        
        if let caloriesConsumed = caloriesConsumed, let caloriesBurned = caloriesBurned {
            progressIndicator = ProgressIndicator(frame: CGRect.zero, progress: caloriesConsumed - caloriesBurned, goal: 2000.0)
            caloriesConsumedView = AnimatedMetric(frame: CGRect.zero, metric: caloriesConsumed, title: "Calories Consumed", image: UIImage(named: "flatwareIcon")!.withRenderingMode(.alwaysTemplate), animationDuration: animationDuration)
            caloriesBurnedView = AnimatedMetric(frame: CGRect.zero, metric: caloriesBurned, title: "Calories Burned", image: UIImage(named: "fire")!.withRenderingMode(.alwaysTemplate), animationDuration: animationDuration)
        } else {
            progressIndicator = ProgressIndicator(frame: CGRect.zero, progress: 0, goal: 2000.0)
            caloriesConsumedView = AnimatedMetric(frame: CGRect.zero, metric: 0, title: "Calories Consumed", image: UIImage(named: "flatwareIcon")!.withRenderingMode(.alwaysTemplate), animationDuration: animationDuration)
            caloriesBurnedView = AnimatedMetric(frame: CGRect.zero, metric: 0, title: "Calories Burned", image: UIImage(named: "fire")!.withRenderingMode(.alwaysTemplate), animationDuration: animationDuration)
        }
        
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
            btmStackView.heightAnchor.constraint(equalTo: progressIndicator.heightAnchor, multiplier: 0.3),
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
        
        guard let protein = self.protein,
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

// MARK: - UIScrollViewDelegate

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

// MARK: - UITableViewDelegate

extension HomeCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Array(getGoalSettings()).count
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
            let goalSetting = Array(getGoalSettings())[indexPath.section]
            let title = goalSetting.key
            cell.title = title
            let goals = merge(goals: goalSetting.value, withValues: nutrients)
            cell.goals = goals
            
            guard let date = date else { return cell }
            // TODO: fix date tomorrow
            if hasAchievedGoals(goals) && !hasShownMessage && Calendar.current.isDateInTomorrow(date) {
                hasShownMessage = true
                delegate?.presentCelebrationView(withTitle: title)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewCellHeight
    }
    
    private func hasAchievedGoals(_ goals: [(String, Double, Double)]) -> Bool {
        for goal in goals {
            if goal.1 < goal.2 { // if progress is smaller than goal
                return false
            }
        }
        return true
    }
    
    private func merge(goals: [String : (String, Double)], withValues values: [HKSampleType : Double]) -> [(String, Double, Double)] {
        var result = [(String, Double, Double)]() // Title, Progress Value, Goal Value
        
        for goal in goals {
            for value in values {
                if goal.key == value.key.identifier {
                    result.append((goal.value.0, value.value, goal.value.1))
                }
            }
        }
        
        return result
    }
    
    private func getGoalSettings() -> [String: [String : (String, Double)]] { // Goal title: [ HKType(string) : Goal Value ]
        let goals = [
            "Diet XYZ":
                [
                    HKQuantityTypeIdentifier.dietaryFatTotal.rawValue : ("Fat", 171.0),
                    HKQuantityTypeIdentifier.dietaryCarbohydrates.rawValue : ("Carbs", 25.0),
                    HKQuantityTypeIdentifier.dietaryProtein.rawValue : ("Protein", 92.0),
            ],
            "Vitamins":
                [
                    HKQuantityTypeIdentifier.dietaryVitaminA.rawValue : ("Vitamin A", 0.0009),
                    HKQuantityTypeIdentifier.dietaryVitaminC.rawValue : ("Vitamin C", 0.09),
                    HKQuantityTypeIdentifier.dietaryVitaminD.rawValue : ("Vitamin D", 0.6),
                    HKQuantityTypeIdentifier.dietaryFolate.rawValue : ("Folate", 0.0004),
            ],
            "Activity":
                [
                    
                    HKQuantityTypeIdentifier.activeEnergyBurned.rawValue : ("Energy burned", 200.0),
                    HKQuantityTypeIdentifier.dietaryEnergyConsumed.rawValue : ("Energy consumed", 2000.0),
            ],
            
            ]
        
        return goals
    }
    
    private func filterNutrients(for nutrients: [HKSampleType : Double], with types: Set<HKQuantityType>) -> [HKSampleType : Double] {
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
