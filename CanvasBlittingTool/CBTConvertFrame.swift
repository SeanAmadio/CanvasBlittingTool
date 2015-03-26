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
    var animationManager:CBTConvertAnimation;
    var frame:HashedFrame;
    var lastFrameOptional:HashedFrame?;
    var frameNumber:Int;
    
    init(animation:CBTConvertAnimation, frame:HashedFrame, lastFrame:HashedFrame?, frameNumber:Int)
    {
        self.animationManager = animation;
        self.frame = frame;
        self.lastFrameOptional = lastFrame;
        self.frameNumber = frameNumber;
    }
    
    override func main()
    {
        //NSLog("--[Convert Frame %i Start]", self.frameNumber);
        
        //If we have a last frame
        if let lastFrame = lastFrameOptional
        {
            if (frame == lastFrame)
            {
                //NSLog("--[Convert Frame %i Skipped: Static Frame]", self.frameNumber);
                return;
            }
            
            //Add operations to compare and write each cell
            for (index, cell) in enumerate(frame.cells)
            {
                let lastCell = lastFrame.cells[index];
                self.queue.addOperation(CBTConvertCell(animation: self.animationManager, destinationIndex: index, frameNumber: self.frameNumber, cell: cell, lastCell: lastCell));
            }
        }
        else
        {
            //Add operations to write each cell
            for (index, cell) in enumerate(frame.cells)
            {
                self.queue.addOperation(CBTConvertCell(animation: self.animationManager, destinationIndex: index, frameNumber: self.frameNumber, cell: cell, lastCell: nil));
            }
        }
        self.queue.waitUntilAllOperationsAreFinished();
        NSLog("--[Convert Frame %i End]", self.frameNumber);
    }
}
