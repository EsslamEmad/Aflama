//
//  CategoryTableViewCell.swift
//  Aflama
//
//  Created by Esslam Emad on 27/2/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 5.0
        categoryImage.clipsToBounds = true
        categoryImage.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
