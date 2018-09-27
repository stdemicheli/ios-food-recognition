//
//  HomeCollectionViewCell.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 26.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

protocol HomeCollectionViewCellDelegate {
    func next()
    func previous()
    // func goToCell(with id: String)
}

class HomeCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: - Properties (public)
    
    let nutritionData = [1]
    var delegate: HomeCollectionViewCellDelegate?
    
    // MARK: - Properties (private)
    
    var tableView: UITableView!
    private let reuseId = "HealthCardCell"
    var headerView: AnimatedHeaderView!
    private var headerViewHeight = UIScreen.main.bounds.size.height / 2.2
    private var headerViewCollapsedHeight: CGFloat = 80.0
    private var headerHeightConstraint: NSLayoutConstraint!
    
    private var prevButton: UIButton!
    private var headerTitle: UILabel!
    private var nextButton: UIButton!
    
    private var mainMetricStackView: UIStackView!
    private var mainMetricSubView: UIView!
    private var mainMetric: UILabel!
    private var mainMetricLabel: UILabel!
    
    private var btmLeftMetric: UILabel!
    private var btmMidMetric: UILabel!
    private var btmRightMetric: UILabel!
    private var btmLeftMetricTitle: UILabel!
    private var btmMidMetricTitle: UILabel!
    private var btmRightMetricTitle: UILabel!
    
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
        setRoundCornerForMainMetric()
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
        headerView = AnimatedHeaderView(frame: CGRect.zero, title: "")
        
        let topStackView = UIStackView()
        prevButton = UIButton(type: .system)
        headerTitle = UILabel()
        nextButton = UIButton(type: .system)
        
        let mainMetricView = UIView()
        mainMetricSubView = UIView()
        mainMetricStackView = UIStackView()
        mainMetric = UILabel()
        mainMetricLabel = UILabel()
        
        let bottomStackView = UIStackView()
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
        
        mainMetricView.translatesAutoresizingMaskIntoConstraints = false
        mainMetricSubView.translatesAutoresizingMaskIntoConstraints = false
        mainMetricStackView.translatesAutoresizingMaskIntoConstraints = false
        mainMetric.translatesAutoresizingMaskIntoConstraints = false
        mainMetricLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
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
        
        headerView.addSubview(mainMetricView)
        mainMetricView.addSubview(mainMetricSubView)
        mainMetricSubView.addSubview(mainMetricStackView)
        mainMetricStackView.addArrangedSubview(mainMetric)
        mainMetricStackView.addArrangedSubview(mainMetricLabel)
        
        headerView.addSubview(bottomStackView)
        bottomStackView.addArrangedSubview(btmLeftStackView)
        bottomStackView.addArrangedSubview(btmMidStackView)
        bottomStackView.addArrangedSubview(btmRightStackView)
        btmLeftStackView.addArrangedSubview(btmLeftMetric)
        btmLeftStackView.addArrangedSubview(btmLeftMetricTitle)
        btmMidStackView.addArrangedSubview(btmMidMetric)
        btmMidStackView.addArrangedSubview(btmMidMetricTitle)
        btmRightStackView.addArrangedSubview(btmRightMetric)
        btmRightStackView.addArrangedSubview(btmRightMetricTitle)
        
        
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerViewHeight)
        headerHeightConstraint.isActive = true
        
        let constraints: [NSLayoutConstraint] = [
            headerView.topAnchor.constraint(equalTo: self.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topStackView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 30),
            topStackView.heightAnchor.constraint(equalToConstant: headerViewCollapsedHeight),
            topStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            topStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            bottomStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
            bottomStackView.heightAnchor.constraint(equalTo: mainMetricView.heightAnchor, multiplier: 0.3),
            bottomStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            bottomStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            mainMetricView.topAnchor.constraint(equalTo: topStackView.bottomAnchor),
            mainMetricView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor),
            mainMetricView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            mainMetricView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            mainMetricSubView.centerXAnchor.constraint(equalTo: mainMetricView.centerXAnchor),
            mainMetricSubView.centerYAnchor.constraint(equalTo: mainMetricView.centerYAnchor),
            mainMetricSubView.heightAnchor.constraint(equalTo: mainMetricView.heightAnchor, multiplier: 0.9),
            mainMetricSubView.widthAnchor.constraint(equalTo: mainMetricView.heightAnchor, multiplier: 0.9),
            mainMetricStackView.topAnchor.constraint(equalTo: mainMetricSubView.topAnchor, constant: 60),
            mainMetricStackView.bottomAnchor.constraint(equalTo: mainMetricSubView.bottomAnchor, constant: -60),
            mainMetricStackView.leadingAnchor.constraint(equalTo: mainMetricSubView.leadingAnchor),
            mainMetricStackView.trailingAnchor.constraint(equalTo: mainMetricSubView.trailingAnchor),
            ]
        NSLayoutConstraint.activate(constraints)
        
        topStackView.axis = .horizontal
        topStackView.distribution = .equalSpacing
        topStackView.alignment = .center
        
        headerTitle.numberOfLines = 1
        headerTitle.textAlignment = .center
        headerTitle.text = "27/09/2018"
        headerTitle.backgroundColor = .green
        
        prevButton.setTitle("PREV", for: .normal)
        prevButton.addTarget(self, action: #selector(previousCell), for: .touchUpInside)
        
        nextButton.setTitle("NEXT", for: .normal)
        nextButton.addTarget(self, action: #selector(nextCell), for: .touchUpInside)
        
        mainMetricStackView.axis = .vertical
        mainMetricStackView.distribution = .fill
        mainMetricStackView.alignment = .center
        
        mainMetric.numberOfLines = 1
        mainMetric.textAlignment = .center
        mainMetric.text = "165165"
        mainMetricSubView.clipsToBounds = true
        mainMetricSubView.layer.borderColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        mainMetricSubView.layer.borderWidth = 10
        mainMetricSubView.backgroundColor = .green
        
        mainMetricLabel.numberOfLines = 1
        mainMetricLabel.textAlignment = .center
        mainMetricLabel.text = "Kcal"
        
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .equalSpacing
        bottomStackView.alignment = .center
        
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
        btmLeftMetric.text = "20%"
        //btmLeftMetric.font = UIFont(name: "System", size: 24.0)
        
        btmMidMetric.numberOfLines = 1
        btmMidMetric.textAlignment = .center
        btmMidMetric.text = "30%"
        
        btmRightMetric.numberOfLines = 1
        btmRightMetric.textAlignment = .center
        btmRightMetric.text = "50%"
        
        
        btmLeftMetricTitle.numberOfLines = 1
        btmLeftMetricTitle.textAlignment = .center
        btmLeftMetricTitle.text = "Carbs"
        btmMidMetricTitle.numberOfLines = 1
        btmMidMetricTitle.textAlignment = .center
        btmMidMetricTitle.text = "Protein"
        btmRightMetricTitle.numberOfLines = 1
        btmRightMetricTitle.textAlignment = .center
        btmRightMetricTitle.text = "Fat"
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.register(HealthCardTableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        
        let constraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ]
        
        NSLayoutConstraint.activate(constraints)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func setRoundCornerForMainMetric() {
        mainMetricSubView.layer.cornerRadius = min(mainMetricSubView.bounds.height, mainMetricSubView.bounds.width) / 2
    }
    
}

extension HomeCollectionViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            self.headerHeightConstraint.constant += abs(scrollView.contentOffset.y)
            headerView.incrementColorAlpha(with: self.headerHeightConstraint.constant)
        } else if scrollView.contentOffset.y > 0 && self.headerHeightConstraint.constant >= headerViewCollapsedHeight {
            // We don't want the header to move up too quickly so we divide the y-offset by 100
            self.headerHeightConstraint.constant -= scrollView.contentOffset.y / 100
            headerView.decrementColorAlpha(with: scrollView.contentOffset.y)
            
            if self.headerHeightConstraint.constant < headerViewCollapsedHeight {
                self.headerHeightConstraint.constant = headerViewCollapsedHeight
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.headerHeightConstraint.constant > headerViewHeight {
            animateHeader()
        }
    }
    
    // Gets called when the scroll comes to a halt
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.headerHeightConstraint.constant > headerViewHeight {
            animateHeader()
        }
    }
    
    func animateHeader() {
        // Set and animate the height constraint back to 150
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.headerHeightConstraint.constant = self.headerViewHeight
            self.layoutIfNeeded()
            self.setRoundCornerForMainMetric()
        }, completion: nil)
        self.layoutSubviews()
    }
    
}

extension HomeCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HealthCardCell", for: indexPath) //as! HealthCardTableViewCell
        
        cell.textLabel?.text = "Hi"
        
        return cell
    }
    
}

