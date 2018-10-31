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

struct NutritionHTTPBody: Encodable {
    
    init(with query: String) {
        self.query = query
    }
    
    var query: String
    var num_servings: Int = 1
    var include_subrecipe: Bool = true
    
}

class Food: Decodable, Equatable {
    
    init(name: String, servingQty: Double, servingUnit: String, fullNutrients: [Nutrient]) {
        self.name = name
        self.servingQuantity = servingQty
        self.servingUnit = servingUnit
        self.fullNutrients = fullNutrients
    }
    
    var name: String
    var servingQuantity: Double
    let servingUnit: String
    var fullNutrients: [Nutrient]
    
    enum CodingKeys: String, CodingKey {
        case name = "food_name"
        case servingQuantity = "serving_qty"
        case servingUnit = "serving_unit"
        case fullNutrients = "full_nutrients"
    }
    
    // TODO: Refactor (with a uuid)
    static func == (lhs: Food, rhs: Food) -> Bool {
        return lhs.name == rhs.name
    }
    
}

class Nutrient: Codable {
    
    init(attributeId: Int, value: Double) {
        self.attributeId = attributeId
        self.value = value
    }
    
    let attributeId: Int
    var value: Double
    var name: String?
    var unit: String?
    
    enum CodingKeys: String, CodingKey {
        case attributeId = "attr_id"
        case value
    }
    
}

struct NutrientDefinition: Decodable {
    
    let attributeId: Int
    let name: String
    let usdaTag: String
    let unit: String
    
    enum CodingKeys: String, CodingKey {
        case attributeId = "attr_id"
        case name
        case usdaTag = "usda_tag"
        case unit
    }
    
}

struct Foods: Decodable {
    
    // var branded: [Food]
    var common: [Food]
    
}

struct FoodError: Decodable {
    
    let message: String
    
}

struct HealthCard {
    
    var title: String
    var items: [HealthCard.Nutrient]
    var type: HealthCardTypes
    
    // TODO: convert into Nutrient struct
    struct Nutrient {
        
        var title: String
        var value: Double
        var unit: String
        var goal: Double
        
    }
    
    enum HealthCardTypes: String {
        case standard
    }
    
}
