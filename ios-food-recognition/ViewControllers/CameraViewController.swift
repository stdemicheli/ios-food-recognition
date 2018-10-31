//
//  CameraViewController.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 25.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    // MARK: - Properties (public)
    let hkController = HealthKitController()
    let foodClient = FoodClient()
    var foodObjects: [String : [Food]] {
        var objects = [String : [Food]]()
        objects["Saved"] = foodClient.savedFoods
        objects["Results"] = foodClient.foodSearchResult
        return objects
    }
    let foodSections = ["Saved", "Results"]
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var headerView: AnimatedHeaderView!
    private var headerViewHeight = UIScreen.main.bounds.size.height / 2.5
    private var headerViewCollapsedHeight: CGFloat = 90.0
    private var headerHeightConstraint: NSLayoutConstraint!
    private let saveButton = UIButton()
    private let retakePhotoButton = UIButton()
    
    @IBOutlet weak var tableView: UITableView!
    private var selectedCellAtIndexPath: IndexPath?
    private var defaultCellHeight: CGFloat = 65.0
    private var expandedCellHeight: CGFloat = 200.0
    
    private var servingQtys: [Int] {
        var qty = [Int]()
        for i in 1..<100 {
            qty.append(i)
        }
        return qty
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        
        searchBar.delegate = self
        
        setupHeader()
        setupTableView()

        // Testing purposes
        headerView.imageView?.image = UIImage(named: "caprese-salad")
        foodClient.fetchFoodInstantly(with: "caprese salad") { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        
        openImagePickerController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Actions
    
    @IBAction func save(_ sender: Any) {
        // Save data to Health Kit
        hkController.saveNutrition(for: foodClient.savedFoods) { (success, error) in
            if success {
                self.tabBarController?.selectedIndex = 1
                self.resetViewController()
            }
        }
        // Spinner
        // Move to Home and update
    }
    
    @IBAction func retake(_ sender: Any) {
        openImagePickerController()
    }
    
    // MARK: - Methods (private)
    
    private func resetViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CameraViewController")
        guard var viewcontrollers = self.navigationController?.viewControllers else { return }
        viewcontrollers.removeLast()
        viewcontrollers.append(vc)
        navigationController?.setViewControllers(viewcontrollers, animated: false)
    }
    
    private func getCalories(for food: Food) -> Double? {
        for nutrient in food.fullNutrients {
            if nutrient.attributeId == 208 {
                return nutrient.value
            }
        }
        
        return nil
    }
    
    private func save(food: Food) {
        if !self.foodClient.savedFoods.contains(food) {
            self.foodClient.savedFoods.append(food)
        }
    }
    
    // TODO: Move to FoodClient?
    // TODO: Make a new server call with food and udpated quantities
    private func update(_ food: Food, with qty: Double) {
        guard let index = foodClient.foodSearchResult.index(of: food) else { return }
        let updatedFood = foodClient.foodSearchResult[index]
        
        let multiplier: Double = qty / Double(updatedFood.servingQuantity)
        
        updatedFood.servingQuantity = qty
        updatedFood.fullNutrients = updatedFood.fullNutrients.map({ (nutrient) -> Nutrient in
            nutrient.value = nutrient.value * multiplier
            return nutrient
        })
    }

}

// MARK: - TableViewDelegate
extension CameraViewController: UITableViewDelegate, UITableViewDataSource, FoodTableCellDelegate {
    
    func updateServingSize(for cell: FoodTableViewCell, withQty qty: Double) {
        guard let food = cell.food else { return }
        _ = update(food, with: qty)
        save(food: food)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return foodSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return foodSections[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let foodSection = foodSections[section]
        return foodObjects[foodSection]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodTableViewCell
        
        cell.delegate = self
//        cell.dataSource = self
        
        let foodSection = foodSections[indexPath.section]
        guard let food = foodObjects[foodSection]?[indexPath.row] else { return cell }
        cell.food = food
        cell.calories = getCalories(for: food)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let save = UITableViewRowAction(style: .normal, title: "Save") { (save, indexPath) in
            let foodSection = self.foodSections[indexPath.section]
            guard let food = self.foodObjects[foodSection]?[indexPath.row] else { return }
            self.save(food: food)
            self.tableView.reloadData()
        }
        save.backgroundColor = .green
        
        let remove = UITableViewRowAction(style: .destructive, title: "Remove") { (remove, indexPath) in
            let foodSection = self.foodSections[indexPath.section]
            guard let food = self.foodObjects[foodSection]?[indexPath.row] else { return }
            guard let index = self.foodClient.savedFoods.index(of: food) else { return }
            self.foodClient.savedFoods.remove(at: index)
            self.foodClient.foodSearchResult.append(food)
            self.tableView.reloadData()
        }
        
        return [save, remove]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellAtIndexPath = selectedCellAtIndexPath == indexPath ? nil : indexPath
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedCellAtIndexPath {
            return expandedCellHeight
        }
        
        return defaultCellHeight
    }
    
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openImagePickerController() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        tabBarController?.selectedIndex = 1
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let activityIndicator = ActivityIndicatorViewController()
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picker.pushViewController(activityIndicator, animated: false)
            
            self.headerView.imageView?.image = image
            foodClient.recognizeFood(with: image) { (error) in
                if let error = error {
                    NSLog("Could not recognize food: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    activityIndicator.endAnimation()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

extension CameraViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        foodClient.fetchFoodInstantly(with: searchText) { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}

extension CameraViewController: UIScrollViewDelegate {
    
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
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    func setupHeader() {
        
        headerView = AnimatedHeaderView(frame: CGRect.zero)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        retakePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        headerView.addSubview(saveButton)
        headerView.addSubview(retakePhotoButton)
        
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerViewHeight)
        headerHeightConstraint.isActive = true
        
        let constraints: [NSLayoutConstraint] = [
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalToConstant: 80),
            retakePhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            retakePhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            retakePhotoButton.widthAnchor.constraint(equalToConstant: 80),
            ]
        NSLayoutConstraint.activate(constraints)
        
        saveButton.setTitle("Done", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font.withSize(20.0)
        saveButton.addTarget(self, action: #selector(save(_:)), for: .touchUpInside)
        saveButton.backgroundColor = .red
        saveButton.layer.cornerRadius = 15
        saveButton.clipsToBounds = true
        
        retakePhotoButton.setTitle("Retake", for: .normal)
        retakePhotoButton.setTitleColor(.white, for: .normal)
        retakePhotoButton.titleLabel?.font.withSize(20.0)
        retakePhotoButton.addTarget(self, action: #selector(retake(_:)), for: .touchUpInside)
        retakePhotoButton.backgroundColor = .red
        retakePhotoButton.layer.cornerRadius = 15
        retakePhotoButton.clipsToBounds = true
        
    }
    
    func setupTableView() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let constraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
}
