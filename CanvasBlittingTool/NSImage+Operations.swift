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
    
    func unscaledBitmapRep() -> NSBitmapImageRep
    {
        var rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(self.size.width), pixelsHigh: Int(self.size.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSDeviceRGBColorSpace, bytesPerRow: 0, bitsPerPixel: 0);
        rep!.size = self.size;
        
        NSGraphicsContext.saveGraphicsState();
        NSGraphicsContext.setCurrentContext(NSGraphicsContext(bitmapImageRep: rep!));

        self.drawAtPoint(NSZeroPoint, fromRect: NSZeroRect, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1.0);

        NSGraphicsContext.restoreGraphicsState();
        
        return rep!;
    }
    
    func writeToPNG(name: String) -> Bool
    {
        var docsDir:AnyObject = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0];
        var databasePath = docsDir.stringByAppendingPathComponent(name);
        self.lockFocus();
        var bitmapRep = self.unscaledBitmapRep();
        self.unlockFocus();
        var data = bitmapRep.representationUsingType(NSBitmapImageFileType.NSPNGFileType, properties: Dictionary<NSObject, AnyObject>());
        return data!.writeToFile(databasePath, atomically: false);
    }
}
