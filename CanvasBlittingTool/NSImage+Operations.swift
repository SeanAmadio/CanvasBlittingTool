//
//  NSImage+Operations.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2015-02-12.
//  Copyright (c) 2015 Two Amadios. All rights reserved.
//

import Foundation
import AppKit

extension NSImage
{
    func isBlack()->Bool
    {
        var data = NSBitmapImageRep(data: self.TIFFRepresentation!);
        for var i = 0; i < Int(self.size.width); ++i
        {
            for var j = 0; j < Int(self.size.height); ++j
            {
                if (data?.colorAtX(i, y: j) != NSColor.blackColor())
                {
                    return false;
                }
            }
        }
        return true;
    }
}
