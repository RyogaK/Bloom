//
//  ProfileCell.swift
//  Bloom
//
//  Created by Ryoga Kitagawa on 4/10/16.
//  Copyright © 2016 Givery. All rights reserved.
//

import UIKit

class ProfileCell : UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImageView.layer.cornerRadius = 64
        self.userImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.userImageView.layer.borderWidth = 2
    }
}
