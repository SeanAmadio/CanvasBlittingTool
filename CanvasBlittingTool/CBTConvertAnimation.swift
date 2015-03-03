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
    var frames:[NSImage];
    var imageCoordinator = CBTImageCoordinator();
    var JSONCoordinator:CBTJSONCoordinator;
    
    init(frames:[NSImage])
    {
        self.frames = frames;
        self.JSONCoordinator = CBTJSONCoordinator(frames: self.frames.count);
    }
    
    override func start()
    {
        NSLog("-[Convert Animation Start]");
        //Set the coordinators for the block content
        CBTConvertBlock.imageCoordinator = self.imageCoordinator;
        CBTConvertBlock.JSONCoordinator = self.JSONCoordinator;
        
        for var index = 0; index < frames.count; ++index
        {
            //For the first image we add a frame comparison with null to the queue so that we will get the initial state
            if (index == 0)
            {
                self.queue.addOperation(CBTConvertFrame(frame: frames[index],lastFrame: nil, frameNumber: index));
            }
            else
            {
                self.queue.addOperation(CBTConvertFrame(frame: frames[index],lastFrame: frames[index-1], frameNumber: index));
            }
        }
        self.queue.waitUntilAllOperationsAreFinished();
        NSLog("-[Convert Animation End]");
    }
}
