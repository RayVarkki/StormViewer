//
//  Picture.swift
//  MilestoneProject4
//
//  Created by Ray Varkki on 2025-10-16.
//

import UIKit

class Picture: NSObject, Codable{

    var image : String
    var imageCaption : String
    
    init(image: String, imageCaption: String) {
        self.image = image
        self.imageCaption = imageCaption
    }
}
