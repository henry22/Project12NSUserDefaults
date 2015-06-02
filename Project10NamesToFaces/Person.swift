//
//  Person.swift
//  Project10NamesToFaces
//
//  Created by Henry on 6/2/15.
//  Copyright (c) 2015 Henry. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        // assign the parameter to the class's property
        self.name = name
        self.image = image
    }
}
