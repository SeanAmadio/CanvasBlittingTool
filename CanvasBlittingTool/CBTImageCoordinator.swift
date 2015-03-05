//
//  CBTImageCoordinator.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2014-12-08.
//  Copyright (c) 2014 Two Amadios. All rights reserved.
//

import Cocoa

class CBTImageCoordinator: CBTCoordinator
{
    var image:CIImage;
    var width:Int = 32;
    var position:BlockPoint;
    
    override init()
    {
        self.position = BlockPoint(x: 0, y: self.width-1);
        self.image = NSImage(size: CGSizeMake(CGFloat(self.width*8), CGFloat(self.width*8))).unscaledCIImage();
        super.init();
    }
    
    func addBlock(block: CIImage, callbackClosure: (BlockPoint) -> Void)
    {
        var operation = NSBlockOperation { () -> Void in
            //Write block at current draw point
            
            let transform = NSAffineTransform();
            transform.translateXBy(self.position.pixelPoint.point.x, yBy: self.position.pixelPoint.point.y);
            NSLog("----[Wrote to %f,%f]", self.position.pixelPoint.point.x, self.position.pixelPoint.point.y);
            
            let shiftFilter = CIFilter(name: "CIAffineTransform");
            shiftFilter.setValue(block, forKey: kCIInputImageKey);
            shiftFilter.setValue(transform, forKey: kCIInputTransformKey);
            
            let compositeFilter = CIFilter(name: "CISourceOverCompositing");
            compositeFilter.setValue(shiftFilter.outputImage, forKey: kCIInputImageKey);
            compositeFilter.setValue(self.image, forKey: kCIInputBackgroundImageKey);
            self.image = compositeFilter.outputImage;
            
            //Callback with point where image was drawn
            callbackClosure(self.position);
            //Move draw point forward
            self.position.x++;
            if (self.position.x == self.width)
            {
                self.position.x = 0;
                self.position.y--;
            }
        };
        self.modifyQueue.addOperation(operation);
    }
}
