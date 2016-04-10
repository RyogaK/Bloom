//
//  ActivityItemCell.swift
//  Bloom
//
//  Created by Ryoga Kitagawa on 4/9/16.
//  Copyright © 2016 Givery. All rights reserved.
//

import UIKit

class ActivityItemCell: UITableViewCell {
    @IBOutlet weak var leftBarView: UIView!
    @IBOutlet weak var leftCircleView: UIView!
    @IBOutlet weak var balloonImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.leftBarView.backgroundColor = UIColor.lightGrayColor()
        self.leftCircleView.layer.cornerRadius = 10
        self.leftCircleView.layer.borderWidth = 2
        self.leftCircleView.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
