//
//  CBTConvertAnimation.swift
//  CanvasBlittingTool
//
//  Breaks the frames down into individual operations that will analyze the change between two given frames
//
//  Created by Sean Amadio on 2014-12-08.
//  Copyright (c) 2014 Two Amadios. All rights reserved.
//
import AppKit

class CBTConvertAnimation: CBTConversionOperation
{
    var frames:[CGImage];
    
    init(frames:[CGImage])
    {
        self.frames = frames;
    }
    
    override func start()
    {
        for var index = 0; index < frames.count; ++index
        {
            //For the first image we add a frame comparison with null to the queue so that we will get the initial state
            if (index == 0)
            {
                self.queue.addOperation(CBTConvertFrame(frame: frames[index],lastFrame: nil));
            }
            else
            {
                self.queue.addOperation(CBTConvertFrame(frame: frames[index],lastFrame: frames[index-1]));
            }
        }
        self.queue.waitUntilAllOperationsAreFinished();
    }
}
