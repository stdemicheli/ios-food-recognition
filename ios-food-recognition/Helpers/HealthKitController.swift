//
//  HealthKitController.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 25.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

// TODO: Think about whether delegate is actually needed
protocol HealthKitControllerDelegate: class {
}

class HealthKitController {
    
    // MARK: - Init
    
    init(typesToWrite: Set<HKSampleType> = Constants.HealthKit().typesToWrite,
         typesToRead: Set<HKObjectType> = Constants.HealthKit().typesToWrite) {
        self.typesToWrite = typesToWrite
        self.typesToRead = typesToRead
    }
    
    // MARK: - Properties
    
    var fetchedNutrients = [HKSampleType : Double]()
    
    private var typesToWrite: Set<HKSampleType>
    private var typesToRead: Set<HKObjectType>
    var healthStore: HKHealthStore? {
        return HKHealthStore.isHealthDataAvailable() ? HKHealthStore() : nil
    }
    
    weak var delegate: HealthKitControllerDelegate?
    
    private enum HKError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
        case persistenceError
    }
    
    // MARK: - Authorization
    
    func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        guard let healthStore = self.healthStore else {
            NSLog("HealthKit is not available on this device")
            completion(false, HKError.notAvailableOnDevice)
            return
        }
        
        healthStore.requestAuthorization(toShare: self.typesToWrite, read: self.typesToRead) { (success, error) in
            completion(success, error)
        }
    }
    
    // Check authorization status for a single HKObject
    func handleHealthKitAuth(forObject type: HKObjectType) {
        guard let healthStore = healthStore else { return }
        let authStatus = healthStore.authorizationStatus(for: type)
        
        if authStatus == .sharingDenied {
            alertUserAboutRestrictedHKAccess()
        } else if authStatus == .notDetermined {
            healthStore.requestAuthorization(toShare: nil, read: Set([type]), completion: { (success, error) in
                if !success {
                    NSLog("Error occured while requesting authorization for HKHealthStore: \(String(describing: error))")
                }
            })
        }
    }
    
    // Alert user if access has been previously denied
    private func alertUserAboutRestrictedHKAccess() {
        if let delegate = delegate as? UIViewController {
            let alert = UIAlertController(title: "Can\'t access health data", message: "Please go to your settings and allow the app access to your health data.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            delegate.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Methods (public)
    
    func fetchNutrition(for date: Date, completion: @escaping (Data?, Error?) -> Void) {
        
    }
    
    func fetchNutrition(from startDate: Date, until endDate: Date, completion: @escaping (Error?) -> Void) {
        let hkNutrients = Constants.HealthKit().commonTypes
        let dispatchGroup = DispatchGroup()
        
        for nutrient in hkNutrients {
            dispatchGroup.enter()
            fetch(nutrient, from: startDate, to: endDate) { (error) in
                if let error = error {
                    NSLog("Error occured while fetching \(nutrient): \(error)")
                    completion(error)
                    return
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(nil)
        }
    }
    
    func saveNutrition(for foods: [Food], completion: @escaping (Bool, Error?) -> Void) {
        for food in foods {
            saveNutrition(for: food) { (success, error) in
                if let error = error {
                    completion(false, error)
                    return
                }
            }
        }
        completion(true, nil)
    }
    
    func saveNutrition(for food: Food, completion: @escaping (Bool, Error?) -> Void) {
        let date = Date()
        let hkObjects = convert(food.fullNutrients)
        let metadata = [
            HKMetadataKeyFoodType : food.name,
            HKMetadataKeyExternalUUID: UUID().uuidString // TODO: save HKobject / or food object to coredata/firebase as a reference
        ]
        guard let foodType = HKObjectType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.food) else {
            fatalError("*** Unable to create the correlation type \(food.name) ***")
        }
        let food = HKCorrelation(type: foodType,
                                 start: date,
                                 end: date,
                                 objects: hkObjects,
                                 metadata: metadata)
        
        healthStore?.save(food, withCompletion: { (success, error) in
            if let error = error {
                NSLog("Error saving data to health store: \(error)")
                completion(false, HKError.persistenceError)
                return
            }

            completion(true, nil)
        })
    }
    
    // MARK: - Methods (private)
    
    private func fetch(_ sampleType: HKSampleType, from startDate: Date, to endDate: Date, completion: @escaping (Error?) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) { (query, results, error) in
            guard let samples = results as? [HKQuantitySample] else {
                completion(error)
                fatalError("An error occured fetching the user's tracked food. The error was: \(String(describing: error?.localizedDescription))")
            }
            
//            Dispatch.main.async?
            
//            guard let foodName =
//                sample.metadata?[HKMetadataKeyFoodType] as? String else {
//                    // if the metadata doesn't record the food type, just skip it.
//                    break
//            }
            
            var sampleQty: Double = 0.0
            for sample in samples {
                sampleQty += sample.quantityType == HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed) ||
                sample.quantityType == HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
                                ? sample.quantity.doubleValue(for: .kilocalorie())
                                : sample.quantity.doubleValue(for: .gram())
                
            }
            
            self.fetchedNutrients[sampleType] = sampleQty
            completion(nil)
        }
        
        healthStore?.execute(query)
    }
    
    
    private func convert(_ nutrients: [Nutrient]) -> Set<HKQuantitySample> {
        let date = Date()
        var hkObjects = Set<HKQuantitySample>()
        
        for nutrient in nutrients {
            switch nutrient.attributeId {
            case 208:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: nutrient.value)
                let sample = HKQuantitySample(type: type,
                                                     quantity: quantity,
                                                     start: date,
                                                     end: date)
                hkObjects.insert(sample)
            case 204:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietaryFatTotal) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.value)
                let sample = HKQuantitySample(type: type,
                                              quantity: quantity,
                                              start: date,
                                              end: date)
                hkObjects.insert(sample)
            case 606:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietaryFatSaturated) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.value)
                let sample = HKQuantitySample(type: type,
                                              quantity: quantity,
                                              start: date,
                                              end: date)
                hkObjects.insert(sample)
            case 645:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietaryFatMonounsaturated) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.value)
                let sample = HKQuantitySample(type: type,
                                              quantity: quantity,
                                              start: date,
                                              end: date)
                hkObjects.insert(sample)
            case 646:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietaryFatPolyunsaturated) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.value)
                let sample = HKQuantitySample(type: type,
                                              quantity: quantity,
                                              start: date,
                                              end: date)
                hkObjects.insert(sample)
            case 601:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietaryCholesterol) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.value/1000)
                let sample = HKQuantitySample(type: type,
                                              quantity: quantity,
                                              start: date,
                                              end: date)
                hkObjects.insert(sample)
            case 205:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.value)
                let sample = HKQuantitySample(type: type,
                                              quantity: quantity,
                                              start: date,
                                              end: date)
                hkObjects.insert(sample)
            case 291:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietaryFiber) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.value)
                let sample = HKQuantitySample(type: type,
                                              quantity: quantity,
                                              start: date,
                                              end: date)
                hkObjects.insert(sample)
            case 269:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietarySugar) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.value)
                let sample = HKQuantitySample(type: type,
                                              quantity: quantity,
                                              start: date,
                                              end: date)
                hkObjects.insert(sample)
            case 203:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietaryProtein) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.value)
                let sample = HKQuantitySample(type: type,
                                              quantity: quantity,
                                              start: date,
                                              end: date)
                hkObjects.insert(sample)
            case 301:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietaryCalcium) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.value/1000)
                let sample = HKQuantitySample(type: type,
                                              quantity: quantity,
                                              start: date,
                                              end: date)
                hkObjects.insert(sample)
            case 303:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietaryIron) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.value/1000)
                let sample = HKQuantitySample(type: type,
                                              quantity: quantity,
                                              start: date,
                                              end: date)
                hkObjects.insert(sample)
            case 306:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietaryPotassium) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.value/1000)
                let sample = HKQuantitySample(type: type,
                                              quantity: quantity,
                                              start: date,
                                              end: date)
                hkObjects.insert(sample)
            case 307:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietarySodium) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.value/1000)
                let sample = HKQuantitySample(type: type,
                                              quantity: quantity,
                                              start: date,
                                              end: date)
                hkObjects.insert(sample)
            case 320:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietaryVitaminA) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.value/1000000)
                let sample = HKQuantitySample(type: type,
                                              quantity: quantity,
                                              start: date,
                                              end: date)
                hkObjects.insert(sample)
            case 401:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietaryVitaminC) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.value/1000)
                let sample = HKQuantitySample(type: type,
                                              quantity: quantity,
                                              start: date,
                                              end: date)
                hkObjects.insert(sample)
            case 328:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietaryVitaminD) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.value/1000000)
                let sample = HKQuantitySample(type: type,
                                              quantity: quantity,
                                              start: date,
                                              end: date)
                hkObjects.insert(sample)
            case 417:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietaryFolate) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.value/1000000)
                let sample = HKQuantitySample(type: type,
                                              quantity: quantity,
                                              start: date,
                                              end: date)
                hkObjects.insert(sample)
            case 262:
                guard let type = HKObjectType.quantityType(forIdentifier: .dietaryCaffeine) else {
                    fatalError("*** Unable to create dietary type \(nutrient.attributeId) ***")
                }
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.value/1000)
                let sample = HKQuantitySample(type: type,
                                              quantity: quantity,
                                              start: date,
                                              end: date)
                hkObjects.insert(sample)
            default:
                    continue
                
            }
        }
        
        return hkObjects
    }
}

