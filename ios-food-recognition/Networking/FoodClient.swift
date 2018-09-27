//
//  FoodClient.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 24.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import UIKit
import Clarifai

class FoodClient {
    
    init(with dataLoader: NetworkDataLoader = URLSession.shared) {
        self.networkLoader = dataLoader
    }
    
    enum HTTPMethods: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: - Properties (public)
    
    var predictions = [ClarifaiConcept]()
    var nutritionInfo: Nutrition?
    var foodSearchResult = [Food]()
    var savedFood = [Food]()
    var nutrientDefinitions: [NutrientDefinition] = {
        let nutrientDefinitions = URL(fileURLWithPath: Bundle.main.path(forResource: "NutrientDefinitions", ofType: "plist")!)
        do {
            return try PropertyListDecoder().decode([NutrientDefinition].self, from: Data(contentsOf: nutrientDefinitions))
        } catch {
            NSLog("Error decoding nutrient definitions from plist: \(error)")
            return []
        }
    }()
    
    // MARK: - Properties (private)
    
    private let networkLoader: NetworkDataLoader
    
    // MARK: - Methods (public)
    
    func recognizeFood(with image: UIImage, completion: @escaping CompletionHandler) {
        predict(with: image) { (error) in
            if let error = error { completion(error); return }
            
            let labels = self.getLabelsForTop(8, in: self.predictions)
            self.fetchFood(with: labels) { (error) in
                if let error = error { completion(error); return }
                
                self.foodSearchResult = self.sync(self.foodSearchResult, with: self.nutrientDefinitions)
                completion(nil)
            }
        }
    }
    
    func fetchFoodInstantly(with query: String, completion: @escaping CompletionHandler) {
        fetchFood(with: query) { (_) in
            completion(nil)
        }
    }
    
    // MARK: - Methods (private)
    
    private func fetchFood(with query: String, completion: @escaping CompletionHandler = { _ in }) {
        let url = URL(string: Constants.Nutritionix.baseURL.rawValue)!
            .appendingPathComponent("search")
            .appendingPathComponent("instant")
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let searchQueryItem = URLQueryItem(name: "query", value: query)
        let isDetailedQueryItem = URLQueryItem(name: "detailed", value: "true")
        let isBrandedQueryItem = URLQueryItem(name: "branded", value: "false")
        urlComponents.queryItems = [searchQueryItem, isDetailedQueryItem, isBrandedQueryItem]
        
        guard let requestURL = urlComponents.url else {
            NSLog("Problem constructing search URL for \(query)")
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethods.get.rawValue
        request.setValue(Constants.Nutritionix.appId.rawValue,
                         forHTTPHeaderField: Constants.Nutritionix.appIdHeader.rawValue)
        request.setValue(Constants.Nutritionix.APIKey.rawValue,
                         forHTTPHeaderField: Constants.Nutritionix.APIKeyHeader.rawValue)

        networkLoader.loadData(from: request) { (data, response, error) in
            if let error = error {
                NSLog("Error while getting food info: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Response did not contain data for food info")
                completion(NSError())
                return
            }
            
            do {
                if let response = response as? HTTPURLResponse, response.statusCode >= 400 {
                    let error = try JSONDecoder().decode(FoodError.self, from: data)
                    NSLog("\(error.message)")
                    completion(NSError())
                    return
                }
                
                let searchResult = try JSONDecoder().decode(Foods.self, from: data)
                self.foodSearchResult.removeAll()
                self.foodSearchResult = searchResult.common
                completion(nil)
            } catch {
                NSLog("Error while decoding food info: \(error)")
                completion(error)
            }
        }
        
    }
    
    private func fetchNutritionInfo(for food: String, completion: @escaping CompletionHandler = { _ in }) {
        let url = URL(string: Constants.Nutritionix.baseURL.rawValue)!
                    .appendingPathComponent("natural")
                    .appendingPathComponent("nutrients")
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.post.rawValue
        request.setValue(Constants.Nutritionix.appId.rawValue,
                         forHTTPHeaderField: Constants.Nutritionix.appIdHeader.rawValue)
        request.setValue(Constants.Nutritionix.APIKey.rawValue,
                         forHTTPHeaderField: Constants.Nutritionix.APIKeyHeader.rawValue)
        request.setValue(Constants.Nutritionix.remoteUserId.rawValue,
                         forHTTPHeaderField: Constants.Nutritionix.remoteUserIdHeader.rawValue)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let nutritionHTTPBody = NutritionHTTPBody(with: food)
            let httpBody = try JSONEncoder().encode(nutritionHTTPBody)
            request.httpBody = httpBody
        } catch {
            NSLog("Error encoding httpBody: \(error)")
            completion(error)
            return
        }
        
        networkLoader.loadData(from: request) { (data, response, error) in
            if let error = error {
                NSLog("Error while getting nutrition info: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Response did not contain data for nutrition info")
                completion(NSError())
                return
            }
            
            do {
                if let response = response as? HTTPURLResponse, response.statusCode >= 400 {
                    let error = try JSONDecoder().decode(FoodError.self, from: data)
                    NSLog("\(error.message)")
                    completion(NSError())
                    return
                }
                
                let searchResult = try JSONDecoder().decode(Nutritions.self, from: data)
                self.nutritionInfo = searchResult.foods.first
                completion(nil)
            } catch {
                NSLog("Error while decoding nutrition info: \(error)")
                completion(error)
            }
            
        }
    }
    
    private func predict(with image: UIImage, completion: @escaping CompletionHandler = { _ in }) {
        let images = ClarifaiImage(image: image)
        let app = ClarifaiApp(apiKey: Constants.Clarifai.APIKey.rawValue)
        if let app = app {
            app.getModelByID(Constants.Clarifai.foodModelVersionID.rawValue) { (model: ClarifaiModel?, error) in
                if let error = error {
                    NSLog("Error while getting model by id: \(error)")
                    completion(error)
                }
                
                model?.predict(on: [images!], completion: { (predictions: [ClarifaiOutput]?, error) in
                    if let error = error {
                        NSLog("Error while getting prediction: \(error)")
                        completion(error)
                    }
                    
                    guard let predictions = predictions else {
                        NSLog("Response did not contain proper data (ClarifaiOutput) for predictions")
                        completion(NSError())
                        return
                    }
                    
                    self.predictions = predictions.first?.concepts ?? []
                    
                    completion(nil)
                    
                })
            }
        }
    }
    
    // TODO: Refactor
    private func sync(_ foods: [Food], with definitions: [NutrientDefinition]) -> [Food] {
        let syncedFoods = foods
        
        for food in syncedFoods {
            let syncedNutrients = food.fullNutrients

            for nutrient in syncedNutrients {
                for definition in definitions {
                    if nutrient.attributeId == definition.attributeId {
                        nutrient.name = definition.name
                        nutrient.unit = definition.unit
                    }
                }
            }
            
            food.fullNutrients = syncedNutrients
        }
        
        return syncedFoods
    }
    
    private func getLabelsForTop(_ max: Int, in labels: [ClarifaiConcept]) -> String {
        return labels.prefix(max).compactMap { $0.conceptName }.joined(separator: " ")
    }
    
}
