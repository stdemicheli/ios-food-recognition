//
//  CameraViewController.swift
//  ios-food-recognition
//
//  Created by De MicheliStefano on 25.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    // MARK: - Properties (public)
    
    let foodClient = FoodClient()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UITableView!
    
    // MARK: - Properties (private)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        openImagePickerController()
    }
    
    // MARK: - Actions
    
    @IBAction func save(_ sender: Any) {
        tabBarController?.selectedIndex = 1
        resetViewController()
        // Save data to Health Kit
        // Spinner
        // Move to Home and update
    }
    
    @IBAction func retake(_ sender: Any) {
        openImagePickerController()
    }
    
    // MARK: - Methods (private)
    
    private func resetViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CameraViewController")
        guard var viewcontrollers = self.navigationController?.viewControllers else { return }
        viewcontrollers.removeLast()
        viewcontrollers.append(vc)
        navigationController?.setViewControllers(viewcontrollers, animated: false)
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

extension CameraViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [1, 2, 3, 4, 5].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
        
        cell.textLabel?.text = "pipi"
        cell.detailTextLabel?.text = "langstrumpf"
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        label.text = "hi"
        cell.accessoryView = label
        
        return cell
    }
    
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openImagePickerController() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        tabBarController?.selectedIndex = 1
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView?.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CameraViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // Instant manual search
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // Manual search submit
    }
    
}
