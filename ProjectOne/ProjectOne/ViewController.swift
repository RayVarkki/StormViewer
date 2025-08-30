//
//  ViewController.swift
//  ProjectOne
//
//  Created by Ray Varkki on 2025-08-25.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]();

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        print(items)
        
        for item in items {
            if item.hasPrefix("nssl"){
                //This is a picture to load
                pictures.append(item)
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(reccomendToOthers))
    }
    
    @objc func reccomendToOthers(){
        let vc = UIAlertController(title: "This App Rocks!", message: "Share it with others!", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Return", style: .default))
        present(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            vc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

