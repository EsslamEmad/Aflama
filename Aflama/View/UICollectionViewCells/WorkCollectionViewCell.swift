//
//  WorkCollectionViewCell.swift
//  Aflama
//
//  Created by Esslam Emad on 7/3/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class WorkCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    var type: Int!
    var url: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
