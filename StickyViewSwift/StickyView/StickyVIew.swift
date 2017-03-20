//
//  Nianhuhu.swift
//  threeBeizer
//
//  Created by DA WENG on 2017/3/16.
//  Copyright © 2017年 DA WENG. All rights reserved.
//

import UIKit

class StickyVIew: UIView {
    
    fileprivate var shapeLayer:CAShapeLayer?
    fileprivate var displaylink:CADisplayLink?
    fileprivate var viewArray:Array<UIView>!
    fileprivate var bezierDotCount:Int!
    fileprivate var waveMaxHeight:CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame:CGRect,fillColor:UIColor,waveMaxHeight:CGFloat){
        
        self.init(frame:frame)
        
        self.waveMaxHeight = waveMaxHeight
        
        viewArray = Array()
        
        bezierDotCount = 7
        for i in 0...bezierDotCount-1 {
            let view = UIView(frame: CGRect(x: Int(self.frame.width)*i/(bezierDotCount-1), y: 0, width: 1, height: 1))
            view.center = CGPoint(x: Int(self.frame.width)*i/(bezierDotCount-1), y: 0)
            self.addSubview(view)
            viewArray.append(view)
        }
        
        shapeLayer = CAShapeLayer()
        shapeLayer?.strokeColor = fillColor.cgColor
        shapeLayer?.fillColor = fillColor.cgColor
        shapeLayer?.path = currentPath()
        self.layer.addSublayer(shapeLayer!)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestire))
        self.addGestureRecognizer(pan)
        
    }
    
    func displayLinkAction(dis:CADisplayLink) {
        
        let rectViewArray:Array = viewArray.map({
            (view) -> UIView in
            let layer = view.layer.presentation()
            let rect:CGRect = layer?.value(forKey: "frame") as! CGRect
            let rectView = UIView(frame: rect)
            return rectView
        })
        
        let width = self.bounds.size.width
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: (rectViewArray[0].center.y)))
        for i in stride(from: 1, to: rectViewArray.count-1, by: 2) {
            path.addQuadCurve(to: (rectViewArray[i+1].center), controlPoint: (rectViewArray[i].center))
        }
        path.addLine(to: CGPoint(x: width, y: self.frame.height))
        path.close()
        
        shapeLayer?.path = path.cgPath
    }
    
    func getPresentRect(view:UIView) -> CGRect {
        let layer = view.layer.presentation()
        let rect:CGRect = layer?.value(forKey: "frame") as! CGRect
        return rect
        
    }
    
    func currentPath() -> CGPath {
        
        let width = self.bounds.size.width
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: viewArray[0].center.y))
        for i in stride(from: 1, to: bezierDotCount-1, by: 2) {
            path.addQuadCurve(to: (viewArray[i+1].center), controlPoint: (viewArray[i].center))
        }
        path.addLine(to: CGPoint(x: width, y: self.frame.height))
        path.close()
        return path.cgPath
        
        
    }
    
    
    func panGestire(gesture:UIPanGestureRecognizer){
        
        if gesture.state == UIGestureRecognizerState.ended || gesture.state == UIGestureRecognizerState.cancelled || gesture.state == UIGestureRecognizerState.failed{
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping:0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: {
                
                
                for i in 0...self.bezierDotCount-1 {
                    
                    self.viewArray[i].center = CGPoint(x: Int(self.frame.width)*i/(self.bezierDotCount-1), y: 0)
                    
                }
                
                self.displaylink = CADisplayLink(target: self, selector: #selector(self.displayLinkAction))
                self.displaylink?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
                
            }, completion: {[weak self] (finish) -> Void in
                
                self?.displaylink?.invalidate()
                
                }
            )
            
        }else{
            
            let additionalHeight = max(gesture.translation(in: self).y, 0)
            let waveHeight = min(additionalHeight*2/3, waveMaxHeight!)
            let baseHeight = additionalHeight-waveHeight
            let locationX = gesture.location(in: self).x
            layoutControlPoints(baseHeight: baseHeight, waveHeight: waveHeight, locationX: locationX)
            shapeLayer?.path = currentPath()
            
        }
        
    }
    
    func layoutControlPoints(baseHeight:CGFloat,waveHeight:CGFloat,locationX:CGFloat) {
        
        let width = self.bounds.size.width
        let minLeftX = CGFloat(0)
        let maxRightX = width
        let leftPartWidth = locationX - minLeftX
        let rightPartWidth = maxRightX - locationX
        viewArray[0].center = CGPoint(x: minLeftX, y: baseHeight)
        viewArray[1].center = CGPoint(x: minLeftX+leftPartWidth/3, y: baseHeight)
        viewArray[2].center = CGPoint(x: minLeftX+leftPartWidth*2/3, y: baseHeight+waveHeight*2/3)
        viewArray[3].center = CGPoint(x: locationX, y: baseHeight+waveHeight*4/3)
        viewArray[4].center = CGPoint(x: maxRightX-rightPartWidth*2/3, y: baseHeight+waveHeight*2/3)
        viewArray[5].center = CGPoint(x: maxRightX-(rightPartWidth/3), y: baseHeight)
        viewArray[6].center = CGPoint(x: maxRightX, y: baseHeight)
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
