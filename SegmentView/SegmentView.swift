//
//  SegmentView.swift
//  ScrollSegmentView
//
//  Created by Shayen on 2017/6/19.
//  Copyright © 2017年 Avocato Technologies. All rights reserved.
//

import UIKit

class SegmentView: UIView {
    
    public var starPoint: CGFloat = 0
    public var delegate:SegmentDelegate?
    
    fileprivate var superVC: UIViewController?
    fileprivate var titleArr: Array<String>?
    fileprivate var btnArr: NSMutableArray?
    fileprivate var markerLine: UIView?
    fileprivate var segmentView: UIView?
    fileprivate var baseLine: UIView?
    fileprivate var segment: UIScrollView?
    fileprivate var selected: UIColor?
    fileprivate var normal: UIColor?
    fileprivate var lastBtn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect,
                     controller: UIViewController,
                     titleArray: Array<String>,
                     segmentH: CGFloat,
                     starIndex: NSInteger,
                     selectedColor: UIColor,
                     normalColor: UIColor,
                     markerLineW: CFloat,
                     markerLineH: CFloat) {
        self.init(frame: frame)
        superVC = controller
        selected = selectedColor
        normal = normalColor
        if starIndex >= 0 && starIndex < titleArray.count {
            starPoint = CGFloat(starIndex)
        }
        let avgWidth: CFloat = CFloat(frame.size.width)/CFloat(titleArray.count)
        titleArr = titleArray
        btnArr = NSMutableArray()
        segmentView = UIView(frame: CGRect(x: 0,
                                           y: 0,
                                           width: bounds.size.width,
                                           height: segmentH))
        segmentView?.backgroundColor = UIColor.white
        addSubview(segmentView!)
        for (index, title) in (titleArr?.enumerated())! {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: CGFloat(index)*(frame.size.width/CGFloat((self.titleArr?.count)!)),
                                  y: 0,
                                  width: frame.size.width/CGFloat((self.titleArr?.count)!),
                                  height: segmentH)
            btn.tag = index
            btn.titleLabel?.font = UIFont(name: "normal", size: 16)
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(normal, for: .normal)
            btn.setTitle(title, for: .selected)
            btn.setTitleColor(selected, for: .selected)
            btn.addTarget(self, action: #selector(clicking(sender:)), for: UIControlEvents.touchUpInside)
            segmentView?.addSubview(btn)
            btnArr?.add(btn)
            if starPoint == CGFloat(index) {
                btn.isSelected = true
                lastBtn = btn
            }
        }
        markerLine = UIView(frame: CGRect(x: CGFloat((avgWidth-markerLineW)/CFloat(2)),
                                          y: segmentH-CGFloat(markerLineH),
                                          width: CGFloat(markerLineW),
                                          height: CGFloat(markerLineH)))
        markerLine?.backgroundColor = selected
        segmentView?.addSubview(markerLine!)
        baseLine = UIView(frame: CGRect(x: 0,
                                        y: CGFloat(segmentH-1),
                                        width: bounds.size.width,
                                        height: CGFloat(1)))
        baseLine?.backgroundColor = normal
        segmentView?.addSubview(baseLine!)
        segment = UIScrollView(frame: CGRect(x: 0,
                                             y: segmentH,
                                             width: bounds.size.width,
                                             height: bounds.size.height - segmentH))
        segment?.delegate = self
        segment?.bounces = false
        segment?.isPagingEnabled = true
        segment?.showsHorizontalScrollIndicator = false
        segment?.contentSize = CGSize(width: bounds.size.width * CGFloat((superVC?.childViewControllers.count)!),
                                      height: 0)
        addSubview(segment!)
        updateChildVC()
        updatePosition(index: CGFloat(starPoint))
    }
    
    @objc func clicking(sender: UIButton) -> () {
        lastBtn?.isSelected = false
        let button = sender
        button.setTitleColor(selected, for: .normal)
        for btn in btnArr! {
            if button != (btn as! UIButton) {
                (btn as! UIButton).setTitleColor(normal, for: .normal)
            }
        }
        segment?.setContentOffset(CGPoint(x: CGFloat(button.tag) * self.bounds.size.width, y: 0), animated: true)
    }
}

extension SegmentView {
    fileprivate func updateChildVC() {
        let index: Int = Int(segment!.contentOffset.x/segment!.frame.size.width)
        let vc: UIViewController = superVC!.childViewControllers[index]
        if !(vc.view.superview != nil) {
            vc.view.frame = CGRect(x:CGFloat(index) * segment!.frame.size.width, y: 0, width: (segment?.frame.size.width)!, height: (segment?.frame.size.height)!)
            self.segment?.addSubview(vc.view)
        }
        self.delegate?.segmentViewDidSelected(segment: segment!, index: index, sender: btnArr?[index] as! UIButton)
    }
    // MARK: Update position
    public func updatePosition(index: CGFloat) {
        if Int(index) >= 0 && Int(index) < (btnArr?.count)! {
            lastBtn?.isSelected = false
            let btn: UIButton = btnArr?[Int(index)] as! UIButton
            btn.isSelected = true
            lastBtn = btn
            segment?.setContentOffset(CGPoint(x: index * self.bounds.size.width, y: 0), animated: true)
        } else {
            print("Warning, out of range")
        }
    }
}

// MARK: - UIScrollViewDelegate
extension SegmentView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var frame = markerLine?.center
        frame?.x = ((bounds.size.width / CGFloat((titleArr?.count)!)) * (segment?.contentOffset.x)! / bounds.size.width) + bounds.size.width / CGFloat((titleArr?.count)!*2)
        markerLine?.center = frame!
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateChildVC()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        lastBtn?.isSelected = false
        let curIndex: Int32 = Int32(scrollView.contentOffset.x/UIScreen.main.bounds.size.width)
        for btn in btnArr! {
            ((btn as! UIButton).tag == curIndex) ? ((btn as! UIButton).setTitleColor(selected, for: .normal)) : ((btn as! UIButton).setTitleColor(normal, for: .normal))
        }
        updateChildVC()
    }
}

// MARK: - SegmentDelegate
protocol SegmentDelegate {
    func segmentViewDidSelected(segment: UIScrollView, index: NSInteger, sender: UIButton)
}
