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
    var displayLinkObject: CVDisplayLink?;
    
    override init() {
        super.init();
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
        
        let p = UnsafeMutablePointer<(displayLink: CVDisplayLink!,
            inNow: UnsafePointer<CVTimeStamp>,
            inOutputTime: UnsafePointer<CVTimeStamp>,
            flagsIn: CVOptionFlags,
            flagsOut: UnsafeMutablePointer<CVOptionFlags>,
            context: UnsafeMutablePointer<Void>) -> CVReturn>.alloc(1) // allocate memory for function
        p.initialize(dlCallback); // initialize with value
        
        let fp = CFunctionPointer<(displayLink: CVDisplayLink!,
            inNow: UnsafePointer<CVTimeStamp>,
            inOutputTime: UnsafePointer<CVTimeStamp>,
            flagsIn: CVOptionFlags,
            flagsOut: UnsafeMutablePointer<CVOptionFlags>,
            context: UnsafeMutablePointer<Void>) -> CVReturn>(COpaquePointer(p)) // convert
       
        let typedPointer = UnsafeMutablePointer<CBTAnimationView>.alloc(1);
        typedPointer.initialize(self);
        
        let voidPointer = UnsafeMutablePointer<Void>(typedPointer);
        
        //CVDisplayLinkSetOutputCallback(displayLinkObject, fp, voidPointer);
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
        //Do shit
        return 0;
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
}
