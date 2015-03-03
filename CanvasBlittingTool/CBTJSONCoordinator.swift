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
    var data:[[[Int]]] = [[[]]];
    
    init (frames: Int)
    {
        data = [[[Int]]](count: frames, repeatedValue: [[]]);
        super.init();
    }
    
    func addBlockData(data: [Int], frame: Int, callbackClosure: () -> Void)
    {
        var operation = NSBlockOperation { () -> Void in
            self.data[frame].append(data);
            callbackClosure();
        };
        self.modifyQueue.addOperation(operation);
    }
}
