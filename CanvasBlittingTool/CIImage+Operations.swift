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
    //Accepts a tolerance from 0-1.0 when testing for a match, 0 meaning the blocks must be exact and 1 meaning they can be completely different
    func needsWrite(tolerance: Float) -> Bool
    {
        //Get the maximum pixel value in the difference image
        let extent = CIVector(x: self.extent().origin.x, y: self.extent().origin.y, z: self.extent().size.width, w: self.extent().size.height);
        let maximum = CIFilter(name:"CIAreaMaximum");
        maximum.setValue(self, forKey:kCIInputImageKey);
        maximum.setValue(extent, forKey:kCIInputExtentKey);
        
        //Get the raw colour data from the single pixel maximum
        let bytesPerPixel = 4;
        var rawData:[CUnsignedChar] = [0,0,0,0];
        let context:CIContext? = NSGraphicsContext(bitmapImageRep: NSBitmapImageRep(CIImage: maximum.outputImage))!.CIContext;
        context!.render(maximum.outputImage, toBitmap: &rawData, rowBytes: 4, bounds: maximum.outputImage.extent(), format: kCIFormatARGB8, colorSpace: CGColorSpaceCreateWithName(kCGColorSpaceGenericRGBLinear));
        
        //Block Difference is the difference between blocks of two frames from 0-765
        let blockDifference = Int(rawData[1])+Int(rawData[2])+Int(rawData[3]);
        let acceptedDifference = Int(765*tolerance);
        
        //If the block difference is within the accepted difference return false (no write needed), otherwise a write is needed
        return !(blockDifference <= acceptedDifference);
    }
    
    //Writes the CIImage to a PNG in the documents folder with the given name
    func writeToPNG(name: String) -> Bool
    {
        var docsDir:AnyObject = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0];
        var databasePath = docsDir.stringByAppendingPathComponent(name);
        var bitmapRep = NSBitmapImageRep(CIImage: self);
        var data = bitmapRep.representationUsingType(NSBitmapImageFileType.NSPNGFileType, properties: Dictionary<NSObject, AnyObject>());
        return data!.writeToFile(databasePath, atomically: false);
    }
    
    //Returns a new cropped image at 0, 0
    func imageByCroppingToRectWithTranslate(rect: CGRect) -> CIImage
    {
        var croppedImage = self.imageByCroppingToRect(rect);
        
        let transform = CIFilter(name:"CIAffineTransform");
        let affineTransform = NSAffineTransform();
        
        affineTransform.translateXBy(-rect.origin.x, yBy:-rect.origin.y);
        transform.setValue(croppedImage, forKey:kCIInputImageKey);
        transform.setValue(affineTransform, forKey:kCIInputTransformKey);
        return transform.outputImage;
    }
}