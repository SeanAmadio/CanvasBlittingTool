//
//  HashedFrame.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2015-03-11.
//  Copyright (c) 2015 Two Amadios. All rights reserved.
//

import Foundation
import AppKit

class HashedFrame
{
    static var context = CIContext();
    //An array of pixel data for the frame
    var data:[CUnsignedChar];
    var cells:[[CUnsignedChar]];
    var width:Int;
    var height:Int;
    
    init(frame:CIImage, settings: Settings)
    {
        self.data = frame.rawData();
        self.cells = Array<Array<CUnsignedChar>>();
        
        let bytesPerPixel = 4;
        for (index, byte) in enumerate(self.data)
        {
            //The index in pixel terms (accounting for 4 bytes per pixel
            var pixelIndex = Int(index / bytesPerPixel);
            
            //The X and Y in pixel space of the image
            var x = pixelIndex % width;
            var y = Int(pixelIndex/width);
            
            var cellIndex = Int(x/settings.cellSize.rawValue) + Int(y/settings.cellSize.rawValue)+ceil(1.0);
            
            self.cells[cell].append(self.data[i]);
        }
        
        self.width = settings.width;
        self.height = settings.height;
    }
    
    //Takes a point in pixel space and returns an index in the data array where you can find that data
    func transformPointToIndex(point: PixelPoint) -> Int
    {
        //Return a negative index if out of bounds
        if (point.x > self.width-1 || point.x < 0 || point.y > self.height-1 || point.y < 0)
        {
            return -1;
        }
        else
        {
            return (point.y*self.width + point.x)*4;    //BytesPerPixel
        }
    }
}