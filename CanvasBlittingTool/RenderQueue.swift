//
//  RenderQueue.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2015-03-22.
//  Copyright (c) 2015 Two Amadios. All rights reserved.
//

import Foundation
import AppKit



class RenderQueue
{
    var queue:[Settings] = [];
    
    func startQueue(images: [NSImage])
    {
        var conversionQueue = NSOperationQueue();
        
        for settings in queue
        {
            conversionQueue.addOperation(CBTConvertAnimation(frames: images, settings: settings));
        }
    }
}