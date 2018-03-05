//
//  GifView.swift
//  Created by Swarup Mahanti on 11/14/16.
//

import Foundation
import UIKit

/**
 * GifImageView: UIView subclass that renders animated images
 */

class GifImageView: UIView, AnimationDelegate {

    private var animator: GifAnimator!
    var playbackSpeed: CGFloat = 1.0 {
        didSet{
            animator.animationSpeed = playbackSpeed
        }
    }

    init(image: UIImage) {
        let box: CGRect = CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height)
        super.init(frame: box)
        self.animator = GifAnimator.init(image: image)
        self.animator.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func play(){
        if !animator.started {
            animator.startAnimation()
        }else{
            animator.resume()
        }
    }

    func pause(){
        animator.pause()
    }

    func animatorDidUpadateFrame() {
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        animator.currentImage().draw(in: rect)
        context?.restoreGState()
    }

}
