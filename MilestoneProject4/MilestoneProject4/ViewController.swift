//
//  ViewController.swift
//  MilestoneProject4
//
//  Created by Ray Varkki on 2025-10-16.
//

import UIKit

class ViewController: UITableViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Image", style: .plain, target: self , action: #selector(pickImage))
        let userDefaults = UserDefaults.standard
        if let savedPictureData = userDefaults.object(forKey: "Pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                 pictures = try jsonDecoder.decode([Picture].self, from: savedPictureData)
            } catch {
                print("Unable to load saved pictures")
            }
        }
    }

    @objc func pickImage(){
        
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
//        var cellContent = cell.defaultContentConfiguration()
//        cellContent.text = pictures[indexPath.row].imageCaption
        cell.textLabel?.text = pictures[indexPath.row].imageCaption
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "PictureController") as? DetailViewController {
            vc.imageName = pictures[indexPath.row].image
            vc.imageCaption = pictures[indexPath.row].imageCaption
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        let imageName = UUID().uuidString
        
        let imagePath = getDocumentsDirectory().appending(path: imageName, directoryHint: .inferFromPath)
        
        if let imageData = image.jpegData(compressionQuality: 0.8){
            try? imageData.write(to: imagePath)
        }
        
        dismiss(animated: true)
        let ac = UIAlertController(title: "Enter a caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            [weak self, weak ac] _ in
            guard let caption = ac?.textFields?.first?.text, !caption.isEmpty else {
                return
            }
            let picture = Picture(image: imagePath.path, imageCaption: caption)
            self?.pictures.append(picture)
            let userDefaults = UserDefaults.standard
            let encoder = JSONEncoder()
            if let encodedPictures = try? encoder.encode(self?.pictures){
                userDefaults.set(encodedPictures, forKey: "Pictures")
            }
            self?.tableView.reloadData()
        }))
        present(ac, animated: true)
    }
    

    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

