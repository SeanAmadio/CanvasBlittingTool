//
//  CBTJSONFrameCoordinator.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2014-12-08.
//  Copyright (c) 2014 Two Amadios. All rights reserved.
//

import Cocoa

class CBTJSONFrameCoordinator: CBTCoordinator
{
    var frameData:[[Int]] = [[]];
    
    func addBlockData(blockData: [Int], callbackClosure: () -> Void)
    {
        var operation = NSBlockOperation { () -> Void in
            self.frameData.append(blockData);
            callbackClosure();
        };
        self.modifyQueue.addOperation(operation);
    }
}
