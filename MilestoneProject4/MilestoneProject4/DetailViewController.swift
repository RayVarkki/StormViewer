//
//  DetailViewController.swift
//  MilestoneProject4
//
//  Created by Ray Varkki on 2025-10-18.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var selectedImage: UIImageView!
    var imageName : String?
    var imageCaption: String?
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = imageCaption
        if let initializedImage = imageName {
            
            selectedImage.image = UIImage(contentsOfFile: initializedImage)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.hidesBarsOnTap = false
    }
}
