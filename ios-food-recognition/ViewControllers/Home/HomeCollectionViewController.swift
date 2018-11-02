//
//  HomeCollectionViewController.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 24.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

private let reuseIdentifier = "HomeCell"

class HomeCollectionViewController: UICollectionViewController {

    // MARK: - Properties (public)
    
    let hkController = HealthKitController()
    var fetchedDates = [(Date, Date)]() // (startDate, EndDate)
    
    // MARK: - Properties (private)
    
    private var cellSize: CGSize!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.cellSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        self.collectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        
        fetchedDates = getDatesByDay(forPastDays: 15)
        
    }

    // MARK: - Methods (public)
    
    func getDatesByDay(forPastDays days: Int) -> [(Date, Date)] {
        var dates = [(Date, Date)]()
        let calendar = Calendar.current
        let now = Date()
        guard let tmrw = calendar.date(byAdding: .day, value: 1, to: now) else { return dates}
        let components = calendar.dateComponents([.year, .month, .day], from: tmrw)
        var currentDate = components
        
        for _ in 0..<days {
            
            guard let startDate = calendar.date(from: currentDate) else {
                fatalError("*** Unable to create the start date ***")
            }
            
            guard let endDate = calendar.date(byAdding: .day, value: -1, to: startDate) else {
                fatalError("*** Unable to create the end date ***")
            }
            
            dates.append((startDate, endDate))
            currentDate = calendar.dateComponents([.year, .month, .day], from: endDate)
        }
        
        return dates
    }
    
    // MARK: - Methods (private)
    
    

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedDates.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        
        cell.delegate = self
        
        let date = fetchedDates[indexPath.item]
        cell.date = date.0
        
        hkController.fetchNutrition(from: date.1, until: date.0) { (error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                return
            }
            
            cell.nutrients = self.hkController.fetchedNutrients
            print(self.hkController.fetchedNutrients)
        }
        
        cell.headerView.backgroundColor = UIColor.red
        
        return cell
    }

}

// MARK: UICollectionViewDelegateFlowLayout

extension HomeCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

// MARK: HomeCollectionViewCellDelegate

extension HomeCollectionViewController: HomeCollectionViewCellDelegate {

    func next() {
        let contentOffset = collectionView.contentOffset
        collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width,
                                                  y: contentOffset.y,
                                                  width: cellSize.width,
                                                  height: cellSize.height), animated: true)
    }
    
    func previous() {
        let contentOffset = collectionView.contentOffset
        collectionView.scrollRectToVisible(CGRect(x: contentOffset.x - cellSize.width,
                                                  y: contentOffset.y,
                                                  width: cellSize.width,
                                                  height: cellSize.height), animated: true)
    }
    
//    func goToCell(with id: String) {
//        let contentOffset = collectionView.contentOffset
//        guard let index = getIndex(for: id) else {
//            NSLog("Could not get index for id: \(id)")
//            return
//        }
//
//        collectionView.scrollRectToVisible(CGRect(x: CGFloat(index) * cellSize.width,
//                                                  y: contentOffset.y,
//                                                  width: cellSize.width,
//                                                  height: cellSize.height), animated: true)
//    }
    

    func presentCelebrationView(withTitle title: String) {
        present(MessageViewController(title: title, message: nil), animated: true, completion: nil)
    }

}
