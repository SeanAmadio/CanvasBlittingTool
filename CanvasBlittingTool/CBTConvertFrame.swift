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
    var frame:CGImage;
    var lastFrame:CGImage?;
    
    init(frame:CGImage, lastFrame:CGImage?)
    {
        self.frame = frame;
        self.lastFrame = lastFrame;
    }
    
    override func start()
    {
        //Loop through all of the blocks
        for var index = 0; index < Int(CGImageGetWidth(frame)); ++index
        {
            //Create the new cropping rectangle and get a subimage from the current frame
            var blockRect = CGRectMake(0.0, 0.0, 8.0, 8.0);
            var block = CGImageCreateWithImageInRect(frame, blockRect);
            
            //If we have data for the previous frame, drop it and queue the block
            if let lastFrameData = lastFrame
            {
                var lastBlock = CGImageCreateWithImageInRect(lastFrameData, blockRect);
                self.queue.addOperation(CBTConvertBlock(block: block, lastBlock: lastBlock));
            }
            else
            {
                //Without a last frame we queue the block with a nil last block
                self.queue.addOperation(CBTConvertBlock(block: block, lastBlock: nil));
            }
        }
        self.queue.waitUntilAllOperationsAreFinished();
    }
}
