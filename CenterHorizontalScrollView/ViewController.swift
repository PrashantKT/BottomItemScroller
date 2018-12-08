//
//  ViewController.swift
//  CenterHorizontalScrollView
//
//  Created by Prashant on 08/12/18.
//  Copyright © 2018 Prashant. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate {

    private var count: Int = 0
    private var currentItem: Int = 0
    private var previousOffset: CGFloat = 0.0
    private var aScrollView: UIScrollView?
    private var parentView: UIView?
    
    private var btnCapture:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        count = 26
        btnCapture = UIButton(type: .custom)
        btnCapture.frame = CGRect(x: (view.frame.size.width - 100) / 2, y: 0 + 20, width: 100, height: 100)
        btnCapture.setImage(UIImage(named: "capture.png"), for: .normal)
        
        setscrollview()
        view.addSubview(btnCapture)
        currentItem = 1
        previousOffset = 0.0
    }

    
    func setscrollview() {
        let aScrollView = UIScrollView(frame: CGRect(x: 0, y: 0 + 20, width: view.frame.size.width, height: 100))
        aScrollView.backgroundColor = UIColor.clear
        aScrollView.delegate = self
        
        parentView = UIView()
        parentView?.frame = aScrollView.bounds
        for i in 0..<count {
            var frame: CGRect
            if i == 0 {
                frame = CGRect(x: (view.frame.size.width - 90) / 2, y: 5, width: 90, height: 90)
            } else {
                frame = CGRect(x: (parentView?.viewWithTag(i)?.frame.origin.x ?? 0.0) + 90, y: 5, width: 90, height: 90)
            }
            let imgProfile = UIImageView(frame: frame)
            
            imgProfile.image = UIImage(named: "tvsize")
            imgProfile.tag = i + 1
            imgProfile.contentMode = .scaleAspectFill
            imgProfile.clipsToBounds = true
            imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2
            imgProfile.backgroundColor = UIColor.red
            parentView?.addSubview(imgProfile)
        }
        
        aScrollView.contentSize = CGSize(width: (parentView?.viewWithTag(count)?.frame.origin.x ?? 0.0) + (parentView?.viewWithTag(1)?.frame.origin.x ?? 0.0) + 90, height: 90)
        parentView?.frame = CGRect(x:0,y:0,width:aScrollView.contentSize.width,height:aScrollView.contentSize.height)
        aScrollView.addSubview(parentView!)
        self.aScrollView = aScrollView
        view.addSubview(aScrollView)
    }
    
    
    func findCenterImages() {
        var arrIntersect = [UIImageView]()
        let convertedRect: CGRect = view.convert(btnCapture.frame, to: parentView)
        
        for  imageview  in parentView?.subviews ?? []  where imageview is UIImageView {
            
            if convertedRect.intersects(imageview.frame) {
                arrIntersect.append(imageview as! UIImageView)
                
            }
        }
        
        
        if arrIntersect.count == 3 {
            arrIntersect.remove(at: 0)
            //    arrIntersect.removeAll(where: { element in element == arrIntersect.first })
        }
        
        
        var frame: CGRect = CGRect.zero
        
        if arrIntersect.count == 1 {
            frame = (arrIntersect[0]).frame
        } else if arrIntersect.count == 2 {
            if convertedRect.intersection((arrIntersect[0]).frame).size.width > convertedRect.intersection((arrIntersect[1] ).frame).size.width {
                frame = (arrIntersect[0]).frame
            } else {
                frame = (arrIntersect[1]).frame
            }
        }
        //TODO: Fix here
        
        let pointX: CGFloat = convertedRect.origin.x - frame.origin.x
        
        
        print("BEFORE",aScrollView!.contentOffset)
   //     UIView.animate(withDuration: 0.12, delay: 0.0, usingSpringWithDamping: 2, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.aScrollView?.contentOffset = CGPoint(x: (self.aScrollView?.contentOffset.x ?? 0) - pointX, y: self.aScrollView?.contentOffset.y ?? 0)
        print("AFTER",aScrollView!.contentOffset)

     //   }) { finished in
            
    //    }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        findCenterImages()
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        findCenterImages()
        
    }
    

}

