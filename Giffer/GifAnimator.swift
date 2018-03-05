//
//  GifAnimator.swift
//  Giffer
//
//  Created by Swarup Mahanti on 9/23/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

/**
 * Animation engine for animating through subimages of the gif
 */

protocol AnimationDelegate: class {
    func animatorDidUpadateFrame()
}

class GifAnimator: NSObject {

    weak var delegate: AnimationDelegate?
    private var image: UIImage!
    private var currentFrame: Int = 0
    private var isVisible: Bool = false
    private var gifTimer: Timer?
    private var frameInterval: Double = 0
    private var numFrames: Int = 0
    var started = false
    var animationSpeed: CGFloat = 1.0 {
        didSet{
            if started {
                gifTimer?.invalidate()
                createTimer()
            }
        }
    }

    init(image: UIImage) {
        self.image = image;
    }

    func startAnimation() {
        if let images = image.images {
            started = true
            numFrames = images.count
            createTimer()
        }
    }

    func createTimer(){
        frameInterval = image.duration / (Double)((CGFloat)(numFrames) * animationSpeed)
        gifTimer = Timer.init(timeInterval: frameInterval, target: self, selector: #selector(updateFrame), userInfo: nil, repeats: true)
        RunLoop.current.add(gifTimer!, forMode: .defaultRunLoopMode)
    }

    func revokeTimer(){
        gifTimer?.invalidate()
        gifTimer = nil
    }

    func currentImage() -> UIImage {
        if let images = image.images {
            return images[currentFrame]
        }
        return image
    }

    func pause(){
        if gifTimer == nil {
            return
        }
        revokeTimer()
    }

    func resume(){
        if gifTimer != nil {
            return
        }
        createTimer()
    }

    @objc func updateFrame() {
        currentFrame += 1
        if currentFrame == numFrames {
            currentFrame = 0 // set to loop for ever
        }
        delegate?.animatorDidUpadateFrame()
    }
}
