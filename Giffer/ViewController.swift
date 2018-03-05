//
//  ViewController.swift
//  Giffer
//
//  Created by Swarup Mahanti on 9/23/17.
//  Copyright © 2017 Swarup Mahanti. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor.clear

        //add gifview
        var box: CGRect = self.view.bounds
        box.origin.y += AppScheme.kStatusBarHeight
        box.size.height -= AppScheme.kStatusBarHeight
        let player: GifPlayer = GifPlayer.init(frame: box)
        self.view.addSubview(player)

        player.setImagePath(path: Bundle.main.path(forResource: "test.gif", ofType: nil)!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

