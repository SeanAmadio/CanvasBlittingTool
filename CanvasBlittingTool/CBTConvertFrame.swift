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
    
    init(frame:NSImage, lastFrame:NSImage?)
    {
        self.frame = frame;
        self.lastFrameOptional = lastFrame;
    }
    
    override func start()
    {
        let cellSize = 8;
        
        var deltaFrameOptional:NSImage?;
        
        if let lastFrame = lastFrameOptional
        {
            //Composite the two frames to get the delta frame
            deltaFrameOptional = NSImage(size: frame.size);
            deltaFrameOptional!.lockFocus();
            frame.drawAtPoint(CGPointMake(0.0,0.0), fromRect: CGRectZero, operation: NSCompositingOperation.CompositeCopy, fraction: 1.0);
            lastFrame.drawAtPoint(CGPointMake(0.0,0.0), fromRect: CGRectZero, operation: NSCompositingOperation.CompositeDifference, fraction: 1.0);
            deltaFrameOptional!.unlockFocus();
            
            //If the whole image is black, no writes need to be done for this frame
            if (deltaFrameOptional!.isBlack())
            {
                return;
            }
        }
        
        //Loop through all of the blocks in the image
        for var cellX = 0; cellX < Int(frame.size.width/8); ++cellX
        {
            for var cellY = 0; cellY < Int(frame.size.height/8); ++cellY
            {
                //Create the new cropping rectangle and get a subimage from the current frame
                var position = CGPointMake(CGFloat(cellX), CGFloat(cellY));
                var blockRect = CGRectMake(CGFloat(cellX), CGFloat(cellY), CGFloat(cellSize), CGFloat(cellSize));
                
                //Write the subimage block of the current frame
                var block = NSImage(size: blockRect.size);
                block.lockFocus();
                frame.drawAtPoint(CGPointMake(0.0,0.0), fromRect: blockRect, operation: NSCompositingOperation.CompositeCopy, fraction: 1.0);
                block.unlockFocus();
                var deltaBlockOptional:NSImage?;
                
                if let deltaFrame = deltaFrameOptional
                {
                    //Write the delta block to an image
                    deltaBlockOptional = NSImage(size: blockRect.size);
                    deltaBlockOptional!.lockFocus();
                    deltaFrame.drawAtPoint(CGPointMake(0.0,0.0), fromRect: blockRect, operation: NSCompositingOperation.CompositeCopy, fraction: 1.0);
                    deltaBlockOptional!.unlockFocus();
                }
                
                //Send the block comparison operation
                self.queue.addOperation(CBTConvertBlock(position: position, block: block, deltaBlock: deltaBlockOptional));
            }
        }
        self.queue.waitUntilAllOperationsAreFinished();
    }
}
