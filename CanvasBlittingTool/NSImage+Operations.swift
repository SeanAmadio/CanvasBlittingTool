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
    
    func writeToPNG(path: String) -> Bool
    {
        self.lockFocus();
        var bitmapRep = self.unscaledBitmapRep();
        self.unlockFocus();
        var data = bitmapRep.representationUsingType(NSBitmapImageFileType.NSPNGFileType, properties: Dictionary<NSObject, AnyObject>());
        return data!.writeToFile(path, atomically: false);
    }
    
    func unscaledCIImage() -> CIImage
    {
        var bitmapRep = self.unscaledBitmapRep();
        return CIImage(bitmapImageRep: bitmapRep)!;
    }
}
