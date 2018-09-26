//
//  FoodTableViewCell.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 26.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

protocol FoodTableViewCellProtocol {
    
}

class FoodTableViewCell: UITableViewCell {
    
    var food: Food? {
        didSet {
            updateViews()
        }
    }
    
    var calories: Double? {
        didSet {
            updateViews()
        }
    }
    
    var indexPath: IndexPath?
    
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var servingTextLabel: UILabel!
    @IBOutlet weak var calorieTextLabel: UILabel!
    
    weak var dataSource: FoodTableCellDataSource?
    weak var delegate: FoodTableCellDelegate?
    
    let picker = UIPickerView()
    private let pickerToolbar = UIToolbar()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        picker.delegate = self
        picker.dataSource = self
    }
    
    private func updateViews() {
        if let food = food {
            nameTextLabel?.text = food.name
            servingTextLabel?.text = "\(Int(food.servingQuantity)) \(food.servingUnit)"
        }
        
        if let calories = calories {
            calorieTextLabel?.text = "\(String(Int(calories))) kcal"
        } else {
            calorieTextLabel?.text = "- kcal"
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        picker.dataSource = self
        delegate?.onPickerOpen(self)
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        delegate?.onPickerClose(self)
        return super.resignFirstResponder()
    }
    
    override var inputView: UIView? {
        return picker
    }
    
    override var inputAccessoryView: UIView? {
        pickerToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(resignFirstResponder))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(resignFirstResponder))
        
        // Can also add more items to toolbar
        pickerToolbar.setItems([doneButton, cancelButton], animated: true)
        pickerToolbar.isUserInteractionEnabled = true
        
        return pickerToolbar
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = self.becomeFirstResponder()
    }
        
}

// MARK: - UIPickerViewDelegate
extension FoodTableViewCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return delegate?.pickerView(pickerView, titleForRow: row, forComponent: component, forCell: self)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.pickerView(pickerView, didSelectRow: row, inComponent: component, forCell: self)
    }
    
}

// MARK: - UIPickerViewDataSource
extension FoodTableViewCell: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataSource?.numberOfComponents(in: pickerView, forCell: self) ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource?.pickerView(pickerView, numberOfRowsInComponent: component, forCell: self) ?? 0
    }
    
}

/// Hook of delegate of `UIPickerView`.
protocol FoodTableCellDelegate: class {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int, forCell cell: FoodTableViewCell) -> String?
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int, forCell cell: FoodTableViewCell)
    
    
    func onPickerOpen(_ cell: FoodTableViewCell)
    
    func onPickerClose(_ cell: FoodTableViewCell)
    
}

/// Hook of datasource of `UIPickerView`.
protocol FoodTableCellDataSource: class {
    
    func numberOfComponents(in pickerView: UIPickerView, forCell cell: FoodTableViewCell) -> Int
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int, forCell cell: FoodTableViewCell) -> Int
    
}
