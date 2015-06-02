//
//  ViewController.swift
//  Project10NamesToFaces
//
//  Created by Henry on 6/1/15.
//  Copyright (c) 2015 Henry. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewPerson")
    }
    
    func addNewPerson() {
        let picker = UIImagePickerController()
        //Allow the user to crop the picture they select
        picker.allowsEditing = true
        //Set self as the delegate, we need to conform not only the UIImagePickerControllerDelegate, but also the UINavigationControllerDelegate protocol
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //If the user cancels the image picker, we dismiss it
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //The info dictionary parameter will contain one of two keys: UIImagePickerControllerEditedImage(the image that was edited) or UIImagePickerControllerOriginalImage,and it should only ever be the former unless changing the allowsEditing property
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var newImage: UIImage
        
        //We can't extract straight into UIImages,because we don't know if these values exist as UIImages,so we need to use an optional method of typecasting as?, along with if/let syntax to make sure we always get the right thing out
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        //We need to generate a unique filename for every image we import, so that we can copy it to our app's space on the disk without overwriting anything, and if the user ever deletes the picture from their photo library we still have our copy. NSUUID(), which generates a Universally Unique Identifier and is perfect for a random filename
        let imageName = NSUUID().UUIDString
        //This is used when working with file paths, and adds one string (imageName in our case) to a path, including whatever path separator is used on the platform
        let imagePath = getDocumentsDirectory().stringByAppendingPathComponent(imageName)
        //Once we have the image, we need to write it to disk. UIImageJPEGRepresentation() converts a UIImage to an NSData, and a quality value between 0 and 100
        let jpegData = UIImageJPEGRepresentation(newImage, 80)
        //There's a method on NSData called writeToFile() that writes its data to disk
        jpegData.writeToFile(imagePath, atomically: true)
        
        //That stores the image name in the Person object and gives them a default name of "Unknown", before reloading the collection view
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        
        collectionView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getDocumentsDirectory() -> String {
        //Its first parameter asks for the documents directory, and its second parameter adds that we want the path to be relative to the user's home directory
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as! [String]
        //It nearly always contains only one thing: the user's documents directory, so we pull out the first element and return it
        let documentsDirectory = path[0]
        return documentsDirectory
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //This must return an integer, and tells the collection view how many items to show in its grid
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    //This must return an object of type UICollectionViewCell,and we already designed a prototype, and configured the PersonCell class for it,so we need to create and return these
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //It creates a collection view cell using the reuse identified we specified, in this case "Person", this method will automatically try to reuse collection view cells, as soon as a cell scrolls out of view it can be recycled
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Person", forIndexPath: indexPath) as! PersonCell
        return cell
    }
}

