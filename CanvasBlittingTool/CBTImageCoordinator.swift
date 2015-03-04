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
    var image:NSImage;
    var width:Float = 1024.0;
    var position:BlockPoint;
    
    override init()
    {
        self.position = BlockPoint(x: 0, y: Int(self.width/8)-1);
        image = NSImage(size: CGSizeMake(CGFloat(self.width), CGFloat(self.width)));
        super.init();
    }
    
    func addBlock(block: NSImage, callbackClosure: (BlockPoint) -> Void)
    {
        var operation = NSBlockOperation { () -> Void in
            //Write block at current draw point
            self.image.lockFocus();
            block.drawAtPoint(self.position.pixelPoint.point, fromRect: CGRectZero, operation: NSCompositingOperation.CompositeCopy, fraction: 1.0);
            self.image.unlockFocus();
            //Callback with point where image was drawn
            callbackClosure(self.position);
            //Move draw point forward
            self.position.x++;
            if (self.position.pixelPoint.x == Int(self.width))
            {
                self.position.x = 0;
                self.position.y--;
            }
        };
        self.modifyQueue.addOperation(operation);
    }
}
