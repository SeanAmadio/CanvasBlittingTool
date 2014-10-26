//
//  CBTAnimationView.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2014-10-26.
//  Copyright (c) 2014 Two Amadios. All rights reserved.
//

import Cocoa

class CBTAnimationView: NSImageView {

    var displayLink: Unmanaged<CVDisplayLink>?;
    
    override init() {
        super.init();
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
        
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    func dlCallback(displayLink: CVDisplayLink!,
        inNow: UnsafePointer<CVTimeStamp>,
        inOutputTime: UnsafePointer<CVTimeStamp>,
        flagsIn: CVOptionFlags,
        flagsOut: UnsafeMutablePointer<CVOptionFlags>,
        context: UnsafeMutablePointer<Void>) -> CVReturn {
            let viewPoint = UnsafeMutablePointer<CBTAnimationView>(context);
            return viewPoint.memory.drawFrame(inOutputTime);
    }
    
    func drawFrame (outputTime: UnsafePointer<CVTimeStamp>) -> CVReturn
    {
        return 0;
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
}
