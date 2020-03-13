//
//  ContentCell.swift
//  Project Maluku
//
//  Created by Andimas Bagaswara on 10/03/20.
//  Copyright © 2020 Andimas Bagaswara. All rights reserved.
//

import UIKit

class ContentCell: UITableViewCell {
    @IBOutlet weak var sentimentBarImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
