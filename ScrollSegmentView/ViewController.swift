//
//  ViewController.swift
//  ScrollSegmentView
//
//  Created by Shayen on 2017/6/19.
//  Copyright © 2017年 Avocato Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var segment: SegmentView?
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
        segment = SegmentView(frame: self.view.bounds,
                                  controller: self,
                                  titleArray: ["first",
                                               "second",
                                               "third"],
                                  segmentH: 44,
                                  starIndex: 3,
                                  selectedColor: UIColor.black,
                                  normalColor: UIColor.lightGray,
                                  markerLineW: 10,
                                  markerLineH: 2)
        segment?.delegate = self
        view.addSubview(segment!)
        
        //segment?.updatePosition(index: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: initialize subviews of segment
extension ViewController {
    fileprivate func initVC() {
        addChildViewController(FirstViewController())
        addChildViewController(SecondViewController())
        addChildViewController(ThirdViewController())
    }
}

// SegmentDelegate
extension ViewController: SegmentDelegate {
    func segmentViewDidSelected(segment: UIScrollView, index: NSInteger, sender: UIButton) {
        print(index)
        print(sender.titleLabel?.text ?? "")
    }
}
