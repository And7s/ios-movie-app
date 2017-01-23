//
//  Pulsing.swift
//  CoreAnimation
//
//  Created by Training on 16/10/2016.
//  Copyright © 2016 Training. All rights reserved.
//

import UIKit

class Pulsing: CALayer {
    
    var animationGroup = CAAnimationGroup()
    
    var initialPulseScale:Float = 1
    var nextPulseAfter:TimeInterval = 0
    var animationDuration:TimeInterval = 1.5
    var radius:CGFloat = 20
    var numberOfPulses:Float = Float.infinity
    var width: CGFloat = 0
    var height: CGFloat = 0
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    init (numberOfPulses:Float = Float.infinity, width: CGFloat, height: CGFloat, position:CGPoint) {
        super.init()
        self.width = width
        self.height = height
        self.backgroundColor = UIColor.black.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
       // self.radius = radius
        self.numberOfPulses = numberOfPulses
        self.position = position
        
        self.bounds = CGRect(x: 0, y: 0, width: width, height: height)
        self.cornerRadius = 0
        
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.setupAnimationGroup()
            
            DispatchQueue.main.async {
                self.add(self.animationGroup, forKey: "pulse")
            }
        }
        
        
        
    }
    
    
    func createScaleAnimation () -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        scaleAnimation.fromValue = NSNumber(value: Float(width))
        scaleAnimation.toValue = NSNumber(value: Float(width + 10))
        scaleAnimation.duration = animationDuration
        
        return scaleAnimation
    }
    
    
    func createHeightAnimation () -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "bounds.size.height")
        scaleAnimation.fromValue = NSNumber(value: Float(height))
        scaleAnimation.toValue = NSNumber(value: Float(height + 10))
        scaleAnimation.duration = animationDuration
        
        return scaleAnimation
    }
    
    func createOpacityAnimation() -> CAKeyframeAnimation {
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [1.0, 0]
        opacityAnimation.keyTimes = [0, 1]
        
        
        return opacityAnimation
    }
    
    func setupAnimationGroup() {
        self.animationGroup = CAAnimationGroup()
        self.animationGroup.duration = animationDuration + nextPulseAfter
        self.animationGroup.repeatCount = numberOfPulses
        
        let defaultCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        self.animationGroup.timingFunction = defaultCurve
        
        self.animationGroup.animations = [createScaleAnimation(), createOpacityAnimation(), createHeightAnimation()]
        
        
    }
    
    
    
}
