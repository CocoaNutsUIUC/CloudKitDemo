//
//  Model.swift
//  CloudKitDemo
//
//  Created by Steven Shang on 10/20/16.
//  Copyright © 2016 Steven Shang. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

protocol ModelDelegate {
    
    func errorUpdating(error: NSError)
    func modelUpdated()
}

class Model {

    static let sharedInstance = Model()
    
    var data: [CKRecord] = []
    
    let container: CKContainer
    let publicDB: CKDatabase
    let userPostType = "UserPost"
    var delegate: ModelDelegate?
    
    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
    }
    
    func currentDate() -> String {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        let dateString = formatter.string(from: date)
        return dateString
        
    }
    
    func retrieveData() {
        
        let predicate = NSPredicate(format: "Date = %@",currentDate())
        let query = CKQuery(recordType: userPostType, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { results, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.errorUpdating(error: error as NSError)
                }
                return;
            }
         
            self.data.removeAll(keepingCapacity: true)
            
            results?.forEach({ (record: CKRecord) in
                
                self.data.append(record)
                
            })
            
            DispatchQueue.main.async {
                self.delegate?.modelUpdated()
            }

        }
    }
    
    func saveData(image: UIImage, date: String) {
        
        let record:CKRecord = CKRecord(recordType: userPostType)
   
        let filename = ProcessInfo.processInfo.globallyUniqueString + ".PNG"
        let url = NSURL.fileURL(withPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        
        let data = UIImagePNGRepresentation(image)!
        do {
            try data.write(to: url, options: Data.WritingOptions.atomicWrite)
        } catch {
            return
        }
    
        let asset = CKAsset(fileURL: url)
        
        record.setValue(asset, forKey: "Image")
        record.setValue(date, forKey: "Date")
        
        publicDB.save(record) { savedRecord, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.errorUpdating(error: error as NSError)
                }
                return;
            }
        }
    }
    
    func loadData(index:Int, completion: @escaping(_ photo: UIImage?, _ date: String?) -> ()) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            var image: UIImage!
            var date: String!
            var record = self.data[index]
            
            defer {
                completion(image, date)
            }
            
            guard let dateData = record["Date"] as? String else {
                return
            }
            
            guard let asset = record["Image"] as? CKAsset else {
                return
            }
                
            let imageData: Data
            
            do {
                imageData = try Data(contentsOf: asset.fileURL)
            } catch {
                return
            }
            
            image = UIImage(data: imageData)
            date = dateData
        }
    }
    
}
