//
//  ViewController.swift
//  Project7
//
//  Created by Ray Varkki on 2025-09-02.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var urlString : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else{
            
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        performSelector(inBackground: #selector(fetchJson), with: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(displayCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterList))

    }
    
    @objc func displayCredits(){
        let ac = UIAlertController(title: "The API is from \(urlString!)", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filterList(){
        
        let ac = UIAlertController(title: "Enter your filter ", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let queryAction = UIAlertAction(title: "Filter", style: .default){
            [weak self] action in
            guard let self else {return}
            guard let query = ac.textFields?[0].text else {return}
            DispatchQueue.global(qos: .userInitiated).async {
                [weak self] in
                guard let self else {return}
                filteredPetitions.removeAll{
                    petition in
                    return !petition.body.contains(query)
                }
                DispatchQueue.main.async {
                    [weak self] in
                    self?.tableView.reloadData()
                }
            }

        }
        ac.addAction(queryAction)
        present(ac, animated: true)
    }
    
    @objc func fetchJson(){
        

            if let url = URL(string: urlString){
                if let data = try? Data(contentsOf: url){
                    parseJson(json: data)
                    return
                }
            }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func showError(){
        
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed. Please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parseJson(json : Data){
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            filteredPetitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else{
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    

}

