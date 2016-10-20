//
//  ViewController.swift
//  CloudKitDemo
//
//  Created by Steven Shang on 10/19/16.
//  Copyright © 2016 Steven Shang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let model:Model = Model.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 450
        
        model.delegate = self
        model.retrieveData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func refreshButtonTapped(_ sender: AnyObject) {
        
        model.retrieveData()
    }
    
    @IBAction func addButtonTapped(_ sender: AnyObject) {
        
        
        let alertController = UIAlertController(title: "Select Image", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (UIAlertAction) in
            self.openCamera()
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: UIAlertActionStyle.default) { (UIAlertAction) in
            self.openLibrary()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func openLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType.isEqual(to: "public.image") {
        
            let imageFile = info[UIImagePickerControllerEditedImage] as! UIImage

            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.medium
            let dateString = formatter.string(from: Date())
            
            model.saveData(image: imageFile, date: dateString)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: Data Source

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! PostTableViewCell
        
        model.loadData(index: indexPath.row) { image, date in
            cell.postImageView.image = image
            cell.dateLabel.text = date
        }
        
        return cell
    }
    
}

// MARK: Model Updating

extension ViewController: ModelDelegate {
    
    func errorUpdating(error: NSError) {
        
        let message = error.localizedDescription
        
        let alertController = UIAlertController(title: "Make Sure You're Logged Into iCloud",
                                                message: message,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func modelUpdated() {
        tableView.reloadData()
    }
    
}
