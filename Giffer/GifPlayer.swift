//
//  GifPlayer.swift
//  Giffer
//
//  Created by Swarup Mahanti on 9/23/17.
//  Copyright © 2017 Swarup Mahanti. All rights reserved.
//

import UIKit

/**
 * GifPlayer along with Play, Pause and Speed Controls
 */

class GifPlayer: UIView {

    private var gifView: GifImageView! // gif rendering view
    private var pauseButton: UIButton! // pause control
    private var playButton: UIButton! // play control
    private var viewRegion: UIBezierPath! // outline to show the viewing area
    private let sliderSteps: [CGFloat] = [0.25, 0.5, 0.75, 1, 2, 4, 6] //speed intervals
    private var slider: FixedIntervalSlider! // stepped slider

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    //MARK:- UI Setup
    func initUI() {

        let size: CGFloat = min(self.bounds.size.width, self.bounds.size.height)
        //add a square area to show view region
        viewRegion = UIBezierPath.init(rect: CGRect.init(x: 0, y: 0, width: size, height: size))
        viewRegion.lineWidth = 3.0
        viewRegion.lineCapStyle = CGLineCap.round

        // add speed slider
        var sliderFrame = CGRect.init()
        sliderFrame.size = CGSize.init(width: self.bounds.size.width - 50, height: AppScheme.kSliderBoxHeight) // extra space for text labels
        sliderFrame.origin.x = self.bounds.midX - sliderFrame.size.width/2
        sliderFrame.origin.y = viewRegion.bounds.maxY + 10
        slider = FixedIntervalSlider.init(frame: sliderFrame)
        slider.numbers = [0.25, 0.50, 0.75, 1, 2, 4, 6]
        slider.addTarget(self, action: #selector(valueChanged(sender:)), for: UIControlEvents.valueChanged)
        self.addSubview(slider)


        //add pause/play at the bottomx
        let btnWidth = AppScheme.kButtonSize.width
        let btnHeight = AppScheme.kButtonSize.height
        let playFrame: CGRect = CGRect.init(x: self.bounds.midX - btnWidth/2, y: self.bounds.maxY - AppScheme.kBottomMargin - btnHeight, width: btnWidth, height: btnHeight)
        playButton = playButton(rect: playFrame)
        self.addSubview(playButton)

        pauseButton = pauseButton(rect: playFrame)
        self.addSubview(pauseButton)
        pauseButton.isHidden = true // hide pause button

    }

    func playButton(rect: CGRect) -> UIButton {
        let button: UIButton = UIButton.init(frame: rect)
        var icon: UIImage = UIImage.init(named: "icons8-Start-50.png")!;
        icon = icon.tinted(tintColor: AppScheme.lightBlue)
        button .setImage(icon, for: UIControlState.normal)
        button.addTarget(self, action: #selector(play), for: UIControlEvents.touchUpInside)
        return button
    }

    func pauseButton(rect: CGRect) -> UIButton {
        let button: UIButton = UIButton.init(frame: rect)
        var icon: UIImage = UIImage.init(named: "icons8-Pause-50.png")!;
        icon = icon.tinted(tintColor: AppScheme.lightBlue)
        button .setImage(icon, for: UIControlState.normal)
        button.addTarget(self, action: #selector(pause), for: UIControlEvents.touchUpInside)
        return button
    }


    func setImagePath(path: String) {
        let fileURL: URL = URL.init(fileURLWithPath: path)
        do {
            let data: Data = try Data.init(contentsOf: fileURL)
            let image: UIImage = UIImage.animatedGIFimage(data: data)
            gifView = GifImageView.init(image: image)
            //adjust frame to keep within bounds
            gifView.frame = positionImageView(imageRect: gifView.frame, viewRect: viewRegion.bounds.insetBy(dx: 5, dy: 5))
            self.addSubview(gifView)
        } catch {
            DEBUGPRINT("error in reading gif data:\(error)")
            return
        }
    }

    //MARK:- Slider callback
    @objc func valueChanged(sender: FixedIntervalSlider) {
        DEBUGPRINT("value:\(String(describing: sender.value))")
        gifView.playbackSpeed = (CGFloat)(sender.value!)
    }
  

    //MARK:- PAUSE/PLAY

    @objc func play() {
        gifView.play()
        playButton.isHidden = true
        pauseButton.isHidden = false
    }

    @objc func pause() {
        gifView.pause()
        pauseButton.isHidden = true
        playButton.isHidden = false
    }

    func positionImageView(imageRect: CGRect, viewRect: CGRect) -> CGRect {
        var imageBox = imageRect

        if !viewRect.contains(imageBox) {
            //shrink to fit to size
            let aspect = imageBox.size.width / imageBox.size.height
            if imageBox.size.height > imageBox.size.width {
                imageBox.size.height = viewRect.size.height
                imageBox.size.width = imageBox.size.height * aspect
            }else {
                imageBox.size.width = viewRect.size.width
                imageBox.size.height = imageBox.size.width / aspect
            }
        }
        //center it
        imageBox.origin.x = viewRect.midX - imageBox.size.width/2
        imageBox.origin.y = viewRect.midY - imageBox.size.height/2
        return imageBox
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let contxt: CGContext = UIGraphicsGetCurrentContext()!
        contxt.saveGState()
        contxt.addPath(viewRegion.cgPath)
        contxt.setStrokeColor(AppScheme.lightBlue.cgColor)
        contxt.strokePath()
        contxt.restoreGState()
    }

}
