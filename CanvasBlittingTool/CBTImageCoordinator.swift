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
    var image:NSImage!;
    var currentDrawPoint = CGPointZero;
    
    func addBlock(block: NSImage, callbackClosure: (CGPoint) -> Void)
    {
        var operation = NSBlockOperation { () -> Void in
            //Write block at current draw point
            //Callback with point where image was drawn
            //Move draw point forward
        };
        self.modifyQueue.addOperation(operation);
    }
}
