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
    var frame:CIImage;
    var lastFrameOptional:CIImage?;
    var frameNumber:Int;
    
    init(frame:CIImage, lastFrame:CIImage?, frameNumber:Int)
    {
        self.frame = frame;
        self.lastFrameOptional = lastFrame;
        self.frameNumber = frameNumber;
    }
    
    override func main()
    {
        NSLog("--[Convert Frame %i Start]", self.frameNumber);
        var deltaFrameOptional:CIImage?;
        
        if let lastFrame = lastFrameOptional
        {
            //Composite the two frames to get the delta frame
            let filter = CIFilter(name: "CIDifferenceBlendMode");
            filter.setValue(frame, forKey: kCIInputImageKey);
            filter.setValue(lastFrame, forKey: kCIInputBackgroundImageKey);
            
            deltaFrameOptional = filter.outputImage;
            
            //Test if anything on this frame needs a write
            if (!deltaFrameOptional!.needsWrite(0.0))
            {
                NSLog("--[Convert Frame %i Skipped: Static Frame]", self.frameNumber);
                return;
            }
        }
        
        //Loop through all of the blocks in the image
        var position = BlockPoint(x: 0, y: 0);
        for position.y = Int(frame.extent().size.height/8)-1; position.y >= 0; position.y--
        {
            for position.x = 0; position.x < Int(frame.extent().size.width/8); position.x++
            {
                //Create the new cropping rectangle and get a subimage from the current frame
                var blockRect = CGRectMake(position.pixelPoint.point.x, position.pixelPoint.point.y, CGFloat(8), CGFloat(8));
                
                var block = frame.imageByCroppingToRectWithTranslate(blockRect);
                var deltaBlockOptional:CIImage?;
                
                if let deltaFrame = deltaFrameOptional
                {
                    //Write the delta block to an image
                    deltaBlockOptional = deltaFrame.imageByCroppingToRectWithTranslate(blockRect);
                }
                
                //Send the block comparison operation
                self.queue.addOperation(CBTConvertBlock(position: position, frameNumber: self.frameNumber, block: block, deltaBlock: deltaBlockOptional));
            }
        }
        self.queue.waitUntilAllOperationsAreFinished();
        NSLog("--[Convert Frame %i End]", self.frameNumber);
    }
}
