//
//  AppScheme.swift
//  Giffer
//
//  Created by Swarup Mahanti on 9/23/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import Foundation
import UIKit

/**
 * App Scheme: uniform colors, button sizes, spaces, margins etc.
 */

struct AppScheme {
    /**
     * http://www.idev101.com/code/User_Interface/sizes.html
     */
    static let kBottomMargin: CGFloat    = 50
    static let kStatusBarHeight: CGFloat = 20
    static let kSliderHeight: CGFloat    = 44
    static let kSliderBoxHeight: CGFloat = 100
    static let kButtonSize: CGSize       = CGSize.init(width: 100, height: 44)
    static let labelFont: UIFont         = UIFont.systemFont(ofSize: 8)

    /**
     * colors based on https://coolors.co/
     */
    static var blue: UIColor {
        return rgba255(red: 0, green: 102, blue: 138, alpha: 255)
    }
    static var lightBlue: UIColor {
        return rgba255(red: 0, green: 173, blue: 215, alpha: 255)
    }
    static var yellow: UIColor {
        return rgba255(red: 241, green: 201, blue: 0, alpha: 255)
    }
    static var beige: UIColor {
        return rgba255(red: 255, green: 241, blue: 206, alpha: 255)
    }
    static var red: UIColor {
        return rgba255(red: 224, green: 23, blue: 6, alpha: 255)
    }
    static func rgba255(red: Int, green: Int, blue: Int, alpha: Int) -> UIColor {
        return UIColor.init(red: (CGFloat)(red)/255.0, green: (CGFloat)(green)/255.0, blue: (CGFloat)(blue)/255.0, alpha: (CGFloat)(alpha)/(255.0))
    }
}
