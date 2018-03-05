//
//  UIImage+Gif.swift
//  Giffer
//
//  Created by Swarup Mahanti on 9/23/17.
//  Copyright © 2017 Swarup Mahanti. All rights reserved.
//

import Foundation
import UIKit

/**
 * UIImage extension to read gif data
 */

extension UIImage {

    class func animatedGIFimage(data: Data) -> UIImage {
        return animatedGIF(source: CGImageSourceCreateWithData(data as NSData as CFData, nil)!)
    }

    private class func animatedGIF(source: CGImageSource) -> UIImage {
        var images: [CGImage] = [CGImage].init()
        var delayCentiseconds: [Int] = [Int].init() // in centiseconds
        createImagesAndDelays(source: source, imagesOut: &images, delayCentisecondsOut: &delayCentiseconds)
        let count: size_t = CGImageSourceGetCount(source)
        let totalDurationInCentiSeconds = sum(values: delayCentiseconds)
        let frames: [UIImage] = framesArray(count: count, images: images, delayCentiseconds: delayCentiseconds, totalDurationCentiseconds: totalDurationInCentiSeconds)
        let animation: UIImage = UIImage.animatedImage(with: frames, duration: (TimeInterval)((Double)(totalDurationInCentiSeconds) / 100.0))!
        return animation
    }

    private class func framesArray(count: size_t, images: [CGImage], delayCentiseconds: [Int], totalDurationCentiseconds: Int) -> [UIImage] {
        let gcd: Int = vectorGCD(values: delayCentiseconds)
        var frames: [UIImage] = [UIImage].init()
        var frameCount: Int = 0
        for i: size_t in 0..<images.count {
            let frame: UIImage = UIImage.init(cgImage: images[i])
            frameCount = Int(delayCentiseconds[Int(i)] / gcd)
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        return frames
    }

    private class func createImagesAndDelays(source: CGImageSource, imagesOut: inout [CGImage], delayCentisecondsOut: inout [Int]){
        let count: size_t = CGImageSourceGetCount(source)
        for i: size_t in 0..<count {
            let image: CGImage = CGImageSourceCreateImageAtIndex(source, i, nil)!
            imagesOut.append(image)
            let delay: Int = delayCentisecondsForImageAtIndex(source: source, i: i)
            delayCentisecondsOut.append(delay)
        }
    }

    private class func delayCentisecondsForImageAtIndex(source: CGImageSource, i: size_t) -> Int {

        var delayInSeconds: Int = 100
        let cfProps: CFDictionary? = CGImageSourceCopyPropertiesAtIndex(source, i, nil)
        let gifPropsPointer: UnsafeMutablePointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProps, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropsPointer) == false {
            return delayInSeconds
        }
        let gifProps: CFDictionary? = unsafeBitCast(gifPropsPointer.pointee, to: CFDictionary.self)
        var delay: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProps, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
        if delay.doubleValue == 0 {
            delay = unsafeBitCast(CFDictionaryGetValue(gifProps, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        let number = delay.doubleValue
        if number! > 0.0 {
            delayInSeconds = Int(round(number! * 100.0))
        }
        return delayInSeconds
    }

    private class func sum(values: [Int]) -> Int {
        var theSum: Int = 0
        for i: size_t in 0..<values.count {
            theSum += values[i]
        }
        return theSum
    }

    private class func vectorGCD(values: [Int]) -> Int{
        var gcd: Int = values[0]
        for i: size_t in 0..<values.count {
            gcd = pairGCD(x: values[i], y: gcd)
        }
        return gcd
    }

    private class func pairGCD(x: Int, y: Int) -> Int {
        var a = x
        var b = y
        if a < b {
            return pairGCD(x: b, y: a)
        }
        while true {
            let r: Int  = a % b
            if r == 0 {
                return b
            }
            a = b
            b = r
        }
    }

    func resizedImage(targetSize: CGSize) -> UIImage {

        let size = self.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize.init(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize.init(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

}
