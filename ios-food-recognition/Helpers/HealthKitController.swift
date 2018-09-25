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
    
    init(typesToWrite: Set<HKSampleType>, typesToRead: Set<HKObjectType>) {
        self.typesToWrite = typesToWrite
        self.typesToRead = typesToRead
    }
    
    // MARK: - Properties
    
    var typesToWrite: Set<HKSampleType>
    var typesToRead: Set<HKObjectType>
    var healthStore: HKHealthStore? {
        return HKHealthStore.isHealthDataAvailable() ? HKHealthStore() : nil
    }
    
    weak var delegate: HealthKitControllerDelegate?
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    // MARK: - Methods
    
    func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        guard let healthStore = self.healthStore else {
            NSLog("HealthKit is not available on this device")
            completion(false, HealthkitSetupError.notAvailableOnDevice)
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
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("User has pressed ok alert occured.")
            }))
            delegate.present(alert, animated: true, completion: nil)
        }
    }
    
}

