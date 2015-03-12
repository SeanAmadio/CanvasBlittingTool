//
//  CBTJSONCoordinator.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2014-12-08.
//  Copyright (c) 2014 Two Amadios. All rights reserved.
//

import Cocoa

class CBTJSONCoordinator: CBTCoordinator
{
    var data:[[[Int]]];
    
    init (frames: Int)
    {
        data = [[[Int]]](count: frames, repeatedValue: []);
        super.init();
    }
    
    //Adds one cell write to our manifest data
    func addCellData(sourceIndex:Int, destinationIndex:Int, frame: Int, callbackClosure: () -> Void)
    {
        var operation = NSBlockOperation { () -> Void in
            self.data[frame].append([sourceIndex, destinationIndex]);
            callbackClosure();
        };
        self.modifyQueue.addOperation(operation);
    }
}
