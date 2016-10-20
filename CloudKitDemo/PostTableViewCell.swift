//
//  PostTableViewCell.swift
//  CloudKitDemo
//
//  Created by Steven Shang on 10/19/16.
//  Copyright © 2016 Steven Shang. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    

}
