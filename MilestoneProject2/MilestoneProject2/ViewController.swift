//
//  ViewController.swift
//  MilestoneProject2
//
//  Created by Ray Varkki on 2025-09-01.
//

import UIKit

class ViewController: UITableViewController {

    
    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shopping List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add item", style: .plain, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear list", style: .plain, target: self, action: #selector(clearList))
        tableView.reloadData()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Hi Sherif :)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func addItem(){
        
        let vc = UIAlertController(title: "What would you like to add?", message: nil, preferredStyle: .alert)
        vc.addTextField();
        vc.addAction(UIAlertAction(title: "Ok", style: .default){
            [weak self, weak vc] action in
            guard let self = self else { return }
            guard let text = vc?.textFields?[0].text else{ return }
            shoppingList.insert(text, at: 0)
            let indexPath = IndexPath(row : 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        })
        present(vc, animated: true)
    }
    
    @objc func clearList(){
        shoppingList.removeAll()
        tableView.reloadData()
    }
}

