//
//  LifelineTableViewCell.swift
//  Women4Women
//
//  Created by Laura Brouckman on 5/23/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class LifelineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lifelineProfilePicture: UIImageView!
    @IBOutlet weak var lifelineNameLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    var username: String?
    var photo_filename: String? {
        didSet {
            updatePhoto()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //updatePhoto()
    }
    
    func updatePhoto() {
        if let filename = photo_filename, !filename.isEmpty
        {
            print(filename)
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let filePath = documentsURL.appendingPathComponent("\(filename)").path
            if FileManager.default.fileExists(atPath: filePath) {
                lifelineProfilePicture.image = UIImage(contentsOfFile: filePath)
                lifelineProfilePicture.layer.cornerRadius = lifelineProfilePicture.frame.size.width / 2;
                lifelineProfilePicture.clipsToBounds = true
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
