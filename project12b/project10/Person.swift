//
//  Person.swift
//  project10
//
//  Created by Ray Varkki on 2025-10-06.
//

import UIKit

class Person: NSObject, Codable {

    var name : String
    var image : String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
