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
    
    static var imageCoordinator:CBTImageCoordinator?;
    static var JSONCoordinator:CBTJSONCoordinator?;
    
    var frames:[NSImage];
    var inputSettings:Settings;
    
    var imageCoordinator = CBTImageCoordinator();
    var JSONCoordinator:CBTJSONCoordinator;

    
    init(frames:[NSImage], settings:Settings)
    {
        self.inputSettings = settings;
        self.frames = frames;
        
        self.JSONCoordinator = CBTJSONCoordinator(frames: settings.frameCount);
    }
    
    override func main()
    {
        NSLog("-[Convert Animation Start]");
        //Set the coordinators for the block content
        CBTConvertAnimation.imageCoordinator = self.imageCoordinator;
        CBTConvertAnimation.JSONCoordinator = self.JSONCoordinator;
        
        var hashedFrames = Array<HashedFrame>();
        
        for var index = 0; index < inputSettings.frameCount; ++index
        {
            hashedFrames.append(HashedFrame(frame: frames[index].unscaledCIImage(), settings: self.inputSettings));
            //For the first image we add a frame comparison with null to the queue so that we will get the initial state
            if (index == 0)
            {
                self.queue.addOperation(CBTConvertFrame(frame: hashedFrames[index], lastFrame: nil, frameNumber: index));
            }
            else
            {
                self.queue.addOperation(CBTConvertFrame(frame: hashedFrames[index], lastFrame: hashedFrames[index-1], frameNumber: index));
            }
        }
        
        
        self.queue.waitUntilAllOperationsAreFinished();
        
        //CBTConvertAnimation.imageCoordinator.image.writeToPNG("output.png");
        NSLog("Written Cells: %i",CBTConvertAnimation.imageCoordinator!.cells.count);
        NSLog("-[Convert Animation End]");
    }
}
