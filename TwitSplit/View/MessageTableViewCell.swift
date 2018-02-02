//
//  MessageTableViewCell.swift
//  TwitSplit
//
//  Created by Mettamdaica on 2/1/18.
//  Copyright © 2018 Mettamdaica. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbMessage: UILabel!
    
    static let cellID = "MessageTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
