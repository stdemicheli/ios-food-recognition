//
//  MessageViewController.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 01.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    var messageTitle: String?
    var messageBody: String?
    var type: String?
    
    convenience init(title: String, message: String?) {
        self.init(nibName: nil, bundle: nil)
        self.messageTitle = title
        self.messageBody = message
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard isViewLoaded else { return }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViews()
    }
    
    private func setupViews() {
        guard let messageTitle = messageTitle else { return }
        let screenBounds = UIScreen.main.bounds
        let frame = CGRect(x: screenBounds.origin.x, y: screenBounds.origin.y, width: screenBounds.width, height: screenBounds.height)
        let celebrationView = CelebrationView(frame: frame, title: messageTitle, message: messageBody)
        view.addSubview(celebrationView)
        
        let dismissButton = UIButton()
        dismissButton.setTitle("Close", for: .normal)
        dismissButton.tintColor = .white
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        celebrationView.addSubview(dismissButton)
        
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingRight: 30, paddingBottom: 0, width: 60, height: 80)
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

}
