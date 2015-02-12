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
    var position:CGPoint;
    var block:NSImage;
    var deltaBlock:NSImage?;
    
    init(position: CGPoint, block:NSImage, deltaBlock:NSImage?)
    {
        self.position = position;
        self.block = block;
        self.deltaBlock = deltaBlock;
    }
    
    override func start()
    {
        //If we have diffBlock data, do the comparison, otherwise assume the block is different and send the write
        if let deltaBlockData = deltaBlock
        {
            if (!deltaBlockData.isBlack())
            {
                //Send a write operation to the imageCoordinator
            }
        }
        else
        {
            //Send a write operation to the imageCoordinator
        }
    }
}
