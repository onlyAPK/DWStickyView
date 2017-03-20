//
//  ViewController.swift
//  StickyView
//
//  Created by DA WENG on 2017/3/20.
//  Copyright © 2017年 DA WENG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let sticky = StickyVIew(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height-100), fillColor: UIColor.orange,waveMaxHeight:150)
        view.addSubview(sticky)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

