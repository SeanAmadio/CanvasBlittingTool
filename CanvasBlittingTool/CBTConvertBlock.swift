//
//  CBTConvertBlock.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2014-12-08.
//  Copyright (c) 2014 Two Amadios. All rights reserved.
//

import AppKit

class CBTConvertBlock: CBTConversionOperation
{
    var destinationPosition:BlockPoint;
    var frameNumber:Int;
    var block:NSImage;
    var deltaBlock:NSImage?;
    
    static var imageCoordinator:CBTImageCoordinator?;
    static var JSONCoordinator:CBTJSONCoordinator?;
    
    init(position: BlockPoint, frameNumber: Int, block:NSImage, deltaBlock:NSImage?)
    {
        self.destinationPosition = position;
        self.frameNumber = frameNumber
        self.block = block;
        self.deltaBlock = deltaBlock;
    }
    
    override func main()
    {
        NSLog("---[Convert Block %i,%i in Frame %i Start]", self.destinationPosition.x, self.destinationPosition.y, self.frameNumber);
        //If we have diffBlock data, do the comparison, otherwise assume the block is different and send the write
        if let deltaBlockData = deltaBlock
        {
            if (!deltaBlockData.isBlack())
            {
                //Send a write operation to the imageCoordinator
                let sem = dispatch_semaphore_create(0);
                CBTConvertBlock.imageCoordinator!.addBlock(block, callbackClosure: { (sourcePosition:BlockPoint) -> Void in
                    CBTConvertBlock.JSONCoordinator!.addBlockData([sourcePosition.x, sourcePosition.y, self.destinationPosition.x, self.destinationPosition.y], frame: self.frameNumber, callbackClosure: { () -> Void in
                        //Dispatch semaphore
                        //NSLog("----Block has changes and was written");
                        dispatch_semaphore_signal(sem);
                    })
                })
                dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            }
        }
        else
        {
            //Send a write operation to the imageCoordinator
            let sem = dispatch_semaphore_create(0);
            CBTConvertBlock.imageCoordinator!.addBlock(block, callbackClosure: { (sourcePosition:BlockPoint) -> Void in
                CBTConvertBlock.JSONCoordinator!.addBlockData([sourcePosition.x, sourcePosition.y, self.destinationPosition.x, self.destinationPosition.y], frame: self.frameNumber, callbackClosure: { () -> Void in
                    //Dispatch semaphore
                    //NSLog("----Block is in frame 0 and was written");
                    dispatch_semaphore_signal(sem);
                })
            })
            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        }
        NSLog("---[Convert Block %i,%i in Frame %i End]", self.destinationPosition.x, self.destinationPosition.y, self.frameNumber);
    }
}
