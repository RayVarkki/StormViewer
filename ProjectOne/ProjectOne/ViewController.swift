//
//  ViewController.swift
//  ProjectOne
//
//  Created by Ray Varkki on 2025-08-25.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var pictures = [String]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        //project 9 adds async
        DispatchQueue.global(qos: .userInitiated).async{
            [weak self] in
            let items = try! fm.contentsOfDirectory(atPath: path)
            for item in items {
                if item.hasPrefix("nssl"){
                    //This is a picture to load
                    self?.pictures.append(item)
                }
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(reccomendToOthers))
    }
    
    @objc func reccomendToOthers(){
        let vc = UIAlertController(title: "This App Rocks!", message: "Share it with others!", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Return", style: .default))
        present(vc, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? ThumbnailCell else{
            fatalError("Unable to dequeue picture")
        }
        cell.thumbnailImage.image = UIImage(named: pictures[indexPath.item])
        cell.imageName.text = pictures[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //This part is a challenge task after project12 which is for saving user states.
        let userDefaults = UserDefaults.standard
        let numberOfTimesClicked = userDefaults.integer(forKey: pictures[indexPath.item])
        let totalClicksAfterCurrentSelection = numberOfTimesClicked + 1
        userDefaults.set(totalClicksAfterCurrentSelection, forKey: pictures[indexPath.item])
        
        print("You clicked \(pictures[indexPath.item]) \(totalClicksAfterCurrentSelection) time(s).")
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            vc.selectedImage = pictures[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

