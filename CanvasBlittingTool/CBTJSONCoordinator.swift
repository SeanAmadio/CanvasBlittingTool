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
    
    func addFrameData(frameData: [[Int]], toIndex: Int, callbackClosure: () -> Void)
    {
        var operation = NSBlockOperation { () -> Void in
            self.data[toIndex] = frameData;
            callbackClosure();
        };
        self.modifyQueue.addOperation(operation);
    }
}
