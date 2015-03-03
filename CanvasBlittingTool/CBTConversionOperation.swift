//
//  CBTConversionOperation.swift
//  CanvasBlittingTool
//
//  This is a base class for all of the conversion operations in the program. It provides basic nested operation functionality
//  Created by Sean Amadio on 2014-12-08.
//  Copyright (c) 2014 Two Amadios. All rights reserved.
//

import Foundation

class CBTConversionOperation: NSOperation
{
    //The queue for any sub operations
    var queue:NSOperationQueue = NSOperationQueue();
    
    override init()
    {
        self.queue.maxConcurrentOperationCount = 1;
        super.init();
    }
}
