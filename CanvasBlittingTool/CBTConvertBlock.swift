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
    var block:CGImage;
    var lastBlock:CGImage?;
    
    init(block:CGImage, lastBlock:CGImage?)
    {
        self.block = block;
        self.lastBlock = lastBlock;
    }
    
    override func start()
    {
        
    }
}
