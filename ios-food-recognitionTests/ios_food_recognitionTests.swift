//
//  ios_food_recognitionTests.swift
//  ios-food-recognitionTests
//
//  Created by De MicheliStefano on 24.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import XCTest
@testable import ios_food_recognition

class MockLoader: NetworkDataLoader {
    
    
    init(data: Data?, error: Error?) {
        self.data = data
        self.error = error
    }
    
    let data: Data?
    let error: Error?
    private(set) var request: URLRequest? = nil
    private(set) var url: URL? = nil
    
    
    func loadData(from request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.request = request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(self.data, nil, self.error)
        }
    }
    
    func loadData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.url = url
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(self.data, nil, self.error)
        }
    }
    
}

class ios_food_recognitionTests: XCTestCase {

    override func setUp() {
        
    }

    override func tearDown() {
        
    }
    
    func testValidNutritionData() {
        let mockLoader = MockLoader(data: validNutritionixJSON, error: nil)
        let foodClient = FoodClient(with: mockLoader)
        
        let expectation = self.expectation(description: "Perform Food Fetch")
        foodClient.fetchFoodInstantly(with: "Grilled Cheese") { (error) in
            XCTAssertNotNil(foodClient.foodSearchResult)
            XCTAssertNil(error)
            print(foodClient.foodSearchResult)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testDecodingToHealthKitDataTypes() {
        let mockLoader = MockLoader(data: validNutritionixJSON, error: nil)
        let foodClient = FoodClient(with: mockLoader)
        let hkController = HealthKitController()
        
        let expectation = self.expectation(description: "Perform Food Fetch")
        foodClient.fetchFoodInstantly(with: "Grilled Cheese") { (error) in
            hkController.saveNutrition(for: foodClient.foodSearchResult, completion: { (success, error) in
                XCTAssertNil(error)
                XCTAssertTrue(success)
                expectation.fulfill()
            })
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetDaysForHomeView() {
        let noOfDays = 10
        let dates = getDatesByDay(forPastDays: noOfDays)
        XCTAssertEqual(dates.count, noOfDays)
    }

}
