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
            self?.pictures += items.filter({ item in
                return item.hasPrefix("nssl")
            })
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendToOthers))
    }
    
    @objc func recommendToOthers(){
        let vc = UIAlertController(title: "This App Rocks!", message: "Share it with others!", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Return", style: .default))
        present(vc, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
//        cell.textLabel?.text = pictures[indexPath.row]
//        return cell
//    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureThumbnail else{
            fatalError("Unable to Dequeue picture thumbnail")
        }
        cell.thumbnailImage.image = UIImage(named: pictures[indexPath.item])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            vc.selectedImage = pictures[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

