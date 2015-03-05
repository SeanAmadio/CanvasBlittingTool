//
//  CIImage+Operations.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2015-03-04.
//  Copyright (c) 2015 Two Amadios. All rights reserved.
//

import Foundation
import AppKit

extension CIImage
{
    
    func writeToPNG(name: String) -> Bool
    {
        var docsDir:AnyObject = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0];
        var databasePath = docsDir.stringByAppendingPathComponent(name);
        var bitmapRep = NSBitmapImageRep(CIImage: self);
        var data = bitmapRep.representationUsingType(NSBitmapImageFileType.NSPNGFileType, properties: Dictionary<NSObject, AnyObject>());
        return data!.writeToFile(databasePath, atomically: false);
    }
    
    func imageByCroppingToRectWithTranslate(rect: CGRect) -> CIImage
    {
        var croppedImage = self.imageByCroppingToRect(rect);
        
        let transform = CIFilter(name:"CIAffineTransform");
        let affineTransform = NSAffineTransform();
        
        affineTransform.translateXBy(-rect.origin.x, yBy:-rect.origin.y);
        transform.setValue(affineTransform, forKey:"inputTransform");
        transform.setValue(croppedImage, forKey:"inputImage");
        return transform.outputImage;
    }
}