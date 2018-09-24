//
//  Prediction.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 24.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

struct Prediction: Codable {

    let id: String
    let name: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case value
    }
    
}

// [data: [concepts: [id: xx, value: 0.98, name: tomato, app_id: main]], input: [id: xx, data: [image[url: www.sdsfs.com]]]]
