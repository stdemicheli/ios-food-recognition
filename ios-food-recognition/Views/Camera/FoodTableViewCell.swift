//
//  FoodTableViewCell.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 26.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

protocol FoodTableCellDelegate: class {
    func updateServingSize(for cell: FoodTableViewCell, withQty qty: Double)
}

class FoodTableViewCell: UITableViewCell {
    
    var food: Food? {
        didSet {
            updateViews()
        }
    }
    
    var nutritionFacts: [String : Double]? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: FoodTableCellDelegate?
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var servingTextLabel: UILabel!
    @IBOutlet weak var calorieTextLabel: UILabel!
    @IBOutlet weak var fatTextLabel: UILabel!
    @IBOutlet weak var carbTextLabel: UILabel!
    @IBOutlet weak var proteinTextLabel: UILabel!
    @IBOutlet weak var servingStepper: UIStepper!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let food = food {
            servingStepper.value = food.servingQuantity
        }
    }
    
    // MARK: - Public
    
    @IBAction func updateServingQty(_ sender: UIStepper) {
        delegate?.updateServingSize(for: self, withQty: sender.value)
    }
    
    // MARK: - Views
    
    private func updateViews() {
        if let food = food {
            nameTextLabel?.text = food.name
            servingTextLabel?.text = "\(Int(food.servingQuantity)) \(food.servingUnit)"
        }
        
        if let calories = nutritionFacts?["calories"], let fat = nutritionFacts?["fat"], let carbs = nutritionFacts?["carbs"], let protein = nutritionFacts?["protein"] {
            calorieTextLabel.numberOfLines = 2
            calorieTextLabel?.text = "\(String(Int(calories))) kcal"
            fatTextLabel?.text = "\(String(Int(fat)))g"
            carbTextLabel?.text = "\(String(Int(carbs)))g"
            proteinTextLabel?.text = "\(String(Int(protein)))g"
        } else {
            calorieTextLabel?.text = "- kcal"
            fatTextLabel?.text = "- g"
            carbTextLabel?.text = "- g"
            proteinTextLabel?.text = "- g"
        }
        
    }
    
}
