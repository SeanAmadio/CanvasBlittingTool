//
//  CBTConvertBlock.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2014-12-08.
//  Copyright (c) 2014 Two Amadios. All rights reserved.
//

import AppKit

class CBTConvertCell: CBTConversionOperation
{
    var destinationIndex:Int;
    var frameNumber:Int;
    var cell:HashedCell;
    var lastCellOptional:HashedCell?;
    
    init(destinationIndex: Int, frameNumber: Int, cell:HashedCell, lastCell:HashedCell?)
    {
        self.destinationIndex = destinationIndex;
        self.frameNumber = frameNumber
        self.cell = cell;
        self.lastCellOptional = lastCell;
    }
    
    override func main()
    {
        //If we have diffBlock data, do the comparison, otherwise assume the block is different and send the write
        if let lastCell = self.lastCellOptional
        {
            if (cell != lastCell)
            {
                sendWrite();
            }
            else
            {
                NSLog("---[Cell %i in Frame %i Skipped: Static Block]", self.destinationIndex, self.frameNumber);
            }
        }
        else
        {
            sendWrite();
        }
    }
    
    func sendWrite()
    {
        //Ask for an image write, when that is done ask for a manifest write, wait until all is done before this operation completes
        let sem = dispatch_semaphore_create(0);
        CBTConvertAnimation.imageCoordinator!.addCell(cell, callbackClosure: { (sourceIndex:Int) -> Void in
            CBTConvertAnimation.JSONCoordinator!.addCellData(sourceIndex, destinationIndex: self.destinationIndex, frame: self.frameNumber, callbackClosure: { () -> Void in
                
                dispatch_semaphore_signal(sem);
            })
        })
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    }
}
