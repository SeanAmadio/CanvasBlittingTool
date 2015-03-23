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
    var settings:Settings;
    
    var imageCoordinator = CBTImageCoordinator();
    var JSONCoordinator:CBTJSONCoordinator;

    
    init(frames:[NSImage], settings:Settings)
    {
        self.settings = settings;
        self.frames = frames;
        
        self.JSONCoordinator = CBTJSONCoordinator(frames: settings.frameCount);
    }
    
    override func main()
    {
        NSLog("-[Convert Animation Start]");
        
        var hashedFrames = Array<HashedFrame>();
        
        for var index = 0; index < settings.frameCount; ++index
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
        
        self.imageCoordinator.writeImage(self.settings.outputPath, name: self.settings.outputName);
        self.JSONCoordinator.writeManifest(self.settings.outputPath, name: self.settings.outputName, version: self.settings.manifestVersion, pretty: self.settings.prettyManifest);
        NSLog("Written Cells: %i",self.imageCoordinator.cells.count);
        NSLog("-[Convert Animation End]");
    }
}
