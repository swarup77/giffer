//
//  Slider.swift
//  Giffer
//
//  Created by Swarup Mahanti on 9/23/17.
//  Copyright © 2017 Swarup Mahanti. All rights reserved.
//

import UIKit

/**
 * custom slider that jumps through a predefined range of values.
 */

class FixedIntervalSlider: UIControl {

    private var slider: UISlider!
    private var valueLabel: UILabel!
    var value: Float?
    var numbers: [Float]? {
        didSet{
            slider.maximumValue = (Float)((numbers?.count)! - 1)
            slider.minimumValue = 0
            slider.value = 3.0
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        // add value label
        valueLabel = UILabel.init(frame: CGRect.init(x: self.bounds.midX - 44, y: 5, width: 88, height: AppScheme.kSliderHeight))
        valueLabel.textColor = AppScheme.lightBlue
        valueLabel.textAlignment = NSTextAlignment.center
        valueLabel.text = "1x"
        self.addSubview(valueLabel)

        // add Slider
        var sliderFrame: CGRect = CGRect.init(x: 0, y: valueLabel.frame.maxY + 5, width: self.bounds.size.width, height: AppScheme.kSliderHeight)
        sliderFrame = sliderFrame.insetBy(dx: 20, dy: 0)
        slider = UISlider.init(frame: sliderFrame)
        slider.addTarget(self, action: #selector(valueChanged(slider:)), for: UIControlEvents.valueChanged)
        slider.minimumTrackTintColor = AppScheme.red
        self.addSubview(slider)

    }

    @objc func valueChanged(slider: UISlider) {
        let index = (Int)(slider.value + 0.5)
        slider.setValue(Float(index), animated: true)
        value = numbers![index]
        valueLabel.text = String.init(format:"\(value!)x")
        sendActions(for: UIControlEvents.valueChanged)
    }

}
