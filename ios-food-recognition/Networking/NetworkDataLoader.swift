//
//  NetworkDataLoader.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 24.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

protocol NetworkDataLoader {
    func loadData(from request: URLRequest, completion: @escaping(Data?, URLResponse?, Error?) -> Void)
    func loadData(from url: URL, completion: @escaping(Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: NetworkDataLoader {
    
    func loadData(from request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: request) { (data, response, error) in
            completion(data, response,  error)
        }.resume()
    }
    
    func loadData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: url) { (data, response, error) in
            completion(data, response,  error)
        }.resume()
    }
    
}
