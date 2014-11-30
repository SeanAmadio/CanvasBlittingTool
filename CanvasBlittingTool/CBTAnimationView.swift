//
//  CBTAnimationView.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2014-10-26.
//  Copyright (c) 2014 Two Amadios. All rights reserved.
//

import Cocoa

class CBTAnimationView: NSImageView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    func setAnimation(images: [NSImage?])
    {
        self.image = images.last!;
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
}
