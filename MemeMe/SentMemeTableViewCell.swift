//
//  SentMemeTableViewCell.swift
//  MemeMe
//
//  Created by James Gilchrist on 3/31/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit

class SentMemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var bottomTextLabel: UILabel!
    @IBOutlet weak var memedImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
