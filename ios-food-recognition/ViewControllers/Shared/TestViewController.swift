//
//  TestViewController.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 29.10.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let progressIndicator = ProgressIndicator(frame: view.frame, progress: 12345)
//        let metric = AnimatedMetric(frame: view.frame, metric: 60, title: "Gagi", image: UIImage(named: "fire")!.withRenderingMode(.alwaysTemplate), animationDuration: 5.0)
//        //metric.backgroundColor = .red
//        view.addSubview(metric)
//        metric.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 75, paddingRight: 50, paddingBottom: 50, width: 120, height: 120)
//        view.addSubview(progressIndicator)
        let celebrationView = CelebrationView(frame: view.frame, title: "", message: "")
        view.addSubview(celebrationView)
        
        //let horizontalBar = HorizontalBar(frame: view.frame, progress: 7, goal: 10)
//        let frame = CGRect(x: 20.0, y: view.bounds.midY, width: view.bounds.width - 50.0, height: 300)
//        let barChart = HorizontalBarChart(frame: frame, data: [("Gagi", 5.0, 10.0), ("Bisi", 5.0, 10.0), ("Bisi", 5.0, 10.0), ("Bisi", 5.0, 10.0)])
//
//        view.addSubview(barChart)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
