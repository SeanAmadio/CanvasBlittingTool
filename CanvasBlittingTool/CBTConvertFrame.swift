//
//  CBTConvertFrame.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2014-12-08.
//  Copyright (c) 2014 Two Amadios. All rights reserved.
//
import AppKit

class CBTConvertFrame: CBTConversionOperation
{
    var frame:NSImage;
    var lastFrameOptional:NSImage?;
    var frameNumber:Int;
    
    init(frame:NSImage, lastFrame:NSImage?, frameNumber:Int)
    {
        self.frame = frame;
        self.lastFrameOptional = lastFrame;
        self.frameNumber = frameNumber;
    }
    
    override func main()
    {
        NSLog("--[Convert Frame %i Start]", self.frameNumber);
        var deltaFrameOptional:NSImage?;
        
        if let lastFrame = lastFrameOptional
        {
            //Composite the two frames to get the delta frame
            deltaFrameOptional = NSImage(size: frame.size);
            deltaFrameOptional!.lockFocus();
            frame.drawAtPoint(CGPointZero, fromRect: CGRectZero, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1.0);
            lastFrame.drawAtPoint(CGPointZero, fromRect: CGRectZero, operation: NSCompositingOperation.CompositeDifference, fraction: 1.0);
            deltaFrameOptional!.unlockFocus();
            
            //If the whole image is black, no writes need to be done for this frame
            if (deltaFrameOptional!.isBlack())
            {
                return;
            }
        }
        
        //Loop through all of the blocks in the image
        var position = BlockPoint(x: 0, y: 0);
        for position.x = 0; position.x < Int(frame.size.width/8); position.x++
        {
            for position.y = Int(frame.size.height/8)-1; position.y >= 0; position.y--
            {
                //Create the new cropping rectangle and get a subimage from the current frame
                var blockRect = CGRectMake(position.pixelPoint.point.x, position.pixelPoint.point.y, CGFloat(8), CGFloat(8));
                
                //Write the subimage block of the current frame
                var block = NSImage(size: blockRect.size);
                block.lockFocus();
                frame.drawAtPoint(CGPointZero, fromRect: blockRect, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1.0);
                block.unlockFocus();
                var deltaBlockOptional:NSImage?;
                
                if let deltaFrame = deltaFrameOptional
                {
                    //Write the delta block to an image
                    deltaBlockOptional = NSImage(size: blockRect.size);
                    deltaBlockOptional!.lockFocus();
                    deltaFrame.drawAtPoint(CGPointZero, fromRect: blockRect, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1.0);
                    deltaBlockOptional!.unlockFocus();
                }
                
                //Send the block comparison operation
                self.queue.addOperation(CBTConvertBlock(position: position, frameNumber: self.frameNumber, block: block, deltaBlock: deltaBlockOptional));
            }
        }
        self.queue.waitUntilAllOperationsAreFinished();
        NSLog("--[Convert Frame %i End]", self.frameNumber);
    }
}
