//
//  UIImage+Tint.swift
//  Giffer
//
//  Created by Swarup Mahanti on 9/23/17.
//  Copyright © 2017 Swarup Mahanti. All rights reserved.
//

import Foundation
import UIKit

/**
 * UIImage extension that allows alpha based tinting
 */

extension UIImage {

    func tinted(tintColor: UIColor) -> UIImage {

        let rect: CGRect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)
        context.draw(self.cgImage!, in: rect)
        context.setBlendMode(CGBlendMode.sourceIn)
        context.setFillColor(tintColor.cgColor)
        context.fill(rect)

        let tinted: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return tinted
    }
}
