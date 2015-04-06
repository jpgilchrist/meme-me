//
//  SentMemeTableViewCell.swift
//  MemeMe
//
//  Created by James Gilchrist on 3/31/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit

class SentMemeTableViewCell: UITableViewCell {
    
    //the image to be displayed in the cell
    @IBOutlet weak var memedImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
