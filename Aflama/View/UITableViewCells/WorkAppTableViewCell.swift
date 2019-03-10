//
//  WorkAppTableViewCell.swift
//  Aflama
//
//  Created by Esslam Emad on 9/3/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class WorkAppTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photo.layer.cornerRadius = 32.0
        photo.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
