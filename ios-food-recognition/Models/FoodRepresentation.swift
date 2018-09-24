//
//  FoodRepresentation.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 24.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

struct Nutrition: Decodable {
    
    let name: String
    let servingQuantity: Int
    let servingUnit: String
    let servingWeightGrams: Double
    let calories: Double
    let totalFat: Double
    let saturatedFat: Double
    let cholesterol: Double
    let sodium: Double
    let totalCarbohydrate: Double
    let dietaryFiber: Double
    let sugars: Double
    let protein: Double
    let potassium: Double
    //let image: URL
    
    enum CodingKeys: String, CodingKey {
        case name = "food_name"
        case servingQuantity = "serving_qty"
        case servingUnit = "serving_unit"
        case servingWeightGrams = "serving_weight_grams"
        case calories = "nf_calories"
        case totalFat = "nf_total_fat"
        case saturatedFat = "nf_saturated_fat"
        case cholesterol = "nf_cholesterol"
        case sodium = "nf_sodium"
        case totalCarbohydrate = "nf_total_carbohydrate"
        case dietaryFiber = "nf_dietary_fiber"
        case sugars = "nf_sugars"
        case protein = "nf_protein"
        case potassium = "nf_potassium"
        //case image
    }
    
}

struct Nutritions: Decodable {
    
    let foods: [Nutrition]
    
}

struct FoodError: Decodable {
    
    let message: String
    
}

struct NutritionHTTPBody: Encodable {
    
    init(with query: String) {
        self.query = query
    }
    
    var query: String
    var num_servings: Int = 1
    var include_subrecipe: Bool = true
    
}

struct FoodHTTPBody: Encodable {
    
    init(with query: String) {
        self.query = query
    }
    
    var query: String
    var detailed: Bool = true
    
}
