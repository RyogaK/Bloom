//
//  ThemeApplier.swift
//  Bloom
//
//  Created by Ryoga Kitagawa on 4/9/16.
//  Copyright © 2016 Givery. All rights reserved.
//

import UIKit

extension UIButton {
    func applyBackgroundTintColor(color: UIColor) {
        self.setBackgroundImage(color.colorImage(), forState: .Normal)
        self.setBackgroundImage(color.highlightedColor().colorImage(), forState: .Highlighted)
    }
    
    func applyPrimaryTheme() {
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.applyBackgroundTintColor(Colors.primaryColor)
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
}

private extension UIColor {
    func colorImage() -> UIImage {
        let size = CGSizeMake(1, 1)
        UIGraphicsBeginImageContext(size)
        
        let rect = CGRect(origin: CGPointZero, size: size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func highlightedColor() -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * 0.5, alpha: alpha)
        } else {
            return self
        }
    }
}
