//
//  DetailViewController.swift
//  MilestoneProject
//
//  Created by Ray Varkki on 2025-08-29.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage : String?
    override func viewDidLoad() {
        super.viewDidLoad()

        title = selectedImage
        if let image = selectedImage{
            
            imageView.image = UIImage(named: image)
            
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePicture))
    }
    
    
    @objc func sharePicture(){
        
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image was found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, selectedImage], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
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
