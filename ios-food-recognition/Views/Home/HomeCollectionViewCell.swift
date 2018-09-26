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
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - HomeCollectionViewCellDelegate
    
    
    
    // MARK: - Views
    
    private func setupViews() {
        setupHeader()
        setupTableView()
        
    }
    
    private func setupHeader() {
        headerView = AnimatedHeaderView(frame: CGRect.zero, title: "")
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(headerView)
        
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerViewHeight)
        headerHeightConstraint.isActive = true
        
        let constraints: [NSLayoutConstraint] = [
            headerView.topAnchor.constraint(equalTo: self.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ]
        NSLayoutConstraint.activate(constraints)
        
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
        }, completion: nil)
    }
    
}

extension HomeCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HealthCardCell", for: indexPath) as! HealthCardTableViewCell
        
        
        
        return cell
    }
    
}

