//
//  CBTAnimationView.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2014-10-26.
//  Copyright (c) 2014 Two Amadios. All rights reserved.
//

import Cocoa

class CBTAnimationView: NSImageView {
    
    var imageArray:[AnyObject]?;
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        self.wantsLayer = true;
        self.layerContentsPlacement = NSViewLayerContentsPlacement.ScaleProportionallyToFit;
    }
    
    func setAnimation(images: [AnyObject])
    {
        self.imageArray = images;
    }
    
    func startAnimation(fps: Int)
    {
        self.layer?.removeAllAnimations();
        
        var animation = CAKeyframeAnimation(keyPath: "contents");
        animation.calculationMode = kCAAnimationDiscrete;
        animation.duration = CFTimeInterval(Double(self.imageArray!.count)/Double(fps));
        animation.repeatCount = Float.infinity;
        animation.values = self.imageArray!;
        
        CATransaction.begin();
        self.layer?.addAnimation(animation, forKey: "contents");
        CATransaction.commit();
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
}
