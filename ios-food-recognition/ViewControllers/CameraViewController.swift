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
    
    let foodClient = FoodClient()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UITableView!
    
    // MARK: - Properties (private)
    
    private let servingQtys = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    private var updatedQty: Double = 1.0
    private var selectedFood: Food?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if let image = imageView?.image {
            //        foodClient.recognizeFood(with: image) { (error) in
            //            if let _ = error {
            //                NSLog("error")
            //                return
            //            }
            //        }
        }
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
        
        foodClient.fetchFoodInstantly(with: "caprese salad") { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        openImagePickerController()
    }
    
    // MARK: - Actions
    
    @IBAction func save(_ sender: Any) {
        tabBarController?.selectedIndex = 1
        resetViewController()
        // Save data to Health Kit
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
    
    private func updateQtys(for food: Food, with qty: Double) -> Food {
        let updatedFood = food
        let multiplier: Double = Double(food.servingQuantity) / qty
        
        updatedFood.fullNutrients = updatedFood.fullNutrients.map({ (nutrient) -> Nutrient in
            nutrient.value = nutrient.value * multiplier
            return nutrient
        })
        
        return updatedFood
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CameraViewController: UITableViewDelegate, UITableViewDataSource, FoodTableCellDataSource, FoodTableCellDelegate {
    func numberOfComponents(in pickerView: UIPickerView, forCell cell: FoodTableViewCell) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int, forCell cell: FoodTableViewCell) -> Int {
        return servingQtys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int, forCell cell: FoodTableViewCell) -> String? {
        return String(servingQtys[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int, forCell cell: FoodTableViewCell) {
        
    }
    
    func onPickerOpen(_ cell: FoodTableViewCell) {
        
    }
    
    func onPickerClose(_ cell: FoodTableViewCell) {
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodClient.foodSearchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodTableViewCell
        
        cell.delegate = self
        cell.dataSource = self
        
        let food = foodClient.foodSearchResult[indexPath.row]
        cell.food = food
        cell.calories = getCalories(for: food)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodTableViewCell
        
        if !cell.isFirstResponder {
            _ = cell.becomeFirstResponder()
        }

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
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView?.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CameraViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // Instant manual search
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // Manual search submit
    }
    
}
