//
//  Person.swift
//  Project10NamesToFaces
//
//  Created by Henry on 6/2/15.
//  Copyright (c) 2015 Henry. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        // assign the parameter to the class's property
        self.name = name
        self.image = image
    }
    
    //required, means "if anyone tries to subclass this class, they are required to implement this method."
    //The initializer is used when loading objects of this class
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        image = aDecoder.decodeObjectForKey("image") as! String
    }
    
    //encodeWithCoder() is used when saving
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(image, forKey: "image")
    }
}
