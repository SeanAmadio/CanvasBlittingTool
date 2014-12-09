//
//  CBTConversionDestinationCoordinator.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2014-12-08.
//  Copyright (c) 2014 Two Amadios. All rights reserved.
//

import Foundation

class CBTCoordinator: NSObject
{
    var modifyQueue = NSOperationQueue();
    
    override init()
    {
        self.modifyQueue.maxConcurrentOperationCount = 1;
        super.init();
    }
    
    
}
