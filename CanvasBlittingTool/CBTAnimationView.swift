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
    }
    
    func setAnimation(images: [AnyObject])
    {
        self.imageArray = images;
        
        var layer = CALayer();
        
        var animation = CAKeyframeAnimation(keyPath: "contents");
        animation.calculationMode = kCAAnimationDiscrete;
        animation.duration = 2;
        animation.repeatCount = Float.infinity;
        animation.values = self.imageArray!;
        
        layer.frame = NSMakeRect(0, 0, self.bounds.width, self.bounds.height);
        layer.bounds = NSMakeRect(0, 0, self.bounds.width, self.bounds.height);
        layer.addAnimation(animation, forKey: "contents");
        
        //Add to the NSImageView layer
        self.layer = layer;
        self.wantsLayer = true;
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
}
