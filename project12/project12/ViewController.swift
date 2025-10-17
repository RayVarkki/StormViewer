//
//  ViewController.swift
//  project12
//
//  Created by Ray Varkki on 2025-10-13.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userdefaults = UserDefaults.standard
        
        userdefaults.set(25, forKey: "age")
        userdefaults.set(true, forKey: "UseFaceID")
        userdefaults.set(CGFloat.pi, forKey: "Pi")
        userdefaults.set("Paul Hudson", forKey: "name")
        userdefaults.set(Date(), forKey: "lastRun")
        
        let array = ["Hello", "World"]
        userdefaults.set(array, forKey: "SavedArray")
        
        let dict = ["Name" : "Paul", "Country" : "UK"]
        userdefaults.set(dict, forKey: "SavedDictionary")
        
        let savedInteger = userdefaults.integer(forKey: "age")
        let savedBoolean = userdefaults.bool(forKey: "UseFaceID")
        let savedCGFloat = userdefaults.float(forKey: "Pi")
        
        let savedArray = userdefaults.object(forKey: "SavedArray") as? [String] ?? [String]()
        let savedDictionary = userdefaults.object(forKey: "SavedDictionary") as? [String : String] ?? [String : String]()
        
        let savedArray2 = userdefaults.array(forKey: "SavedArray")
    }


}

