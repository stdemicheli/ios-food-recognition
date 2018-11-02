//
//  ActivityIndicatorViewController.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 29.10.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class ActivityIndicatorViewController: UIViewController, CAAnimationDelegate {
    
    // MARK: - Properties
    var activityIndicator: ActivityIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenBounds = UIScreen.main.bounds
        let frame = CGRect(x: screenBounds.origin.x, y: screenBounds.origin.y, width: screenBounds.width, height: screenBounds.height)
        activityIndicator = ActivityIndicator(frame: frame)
        view.addSubview(activityIndicator)
    }
    
    // MARK: - Public
    
    func endAnimation() {
        activityIndicator.endAnimation()
    }

}
