//
//  HashedFrame.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2015-03-11.
//  Copyright (c) 2015 Two Amadios. All rights reserved.
//

import Foundation
import AppKit

func ==(lhs: HashedFrame, rhs: HashedFrame) -> Bool
{
    return lhs.hashValue == rhs.hashValue;
}

//Describing cell metadata
struct Settings
{
    //Animation properties
    var width:Int;
    var height:Int;
    var frameCount:Int;
    
    //Cell size
    var cellSize:Int;
    var cellRows:Int
    {
        get
        {
            return Int(ceil(Float(width)/Float(cellSize)));
        }
    }
    
    var cellColumns:Int
    {
        get
        {
            return Int(ceil(Float(height)/Float(cellSize)));
        }
    }
    
    var cells:Int
    {
        get
        {
            return cellRows*cellColumns;
        }
    }
    
    //Returns the numbers of bits needed to represent these dimensions
    var bits:Int
    {
        get
        {
            return Int(ceil(log2(Double(cells))));
        }
    }
}

class HashedFrame : Hashable, Printable
{
    //An array of pixel data
    var cells:[HashedCell];
    
    init(frame:CIImage, settings: Settings)
    {
        //Fill with null data
        self.cells = Array<HashedCell>();
        
        //Parse into the cells array
        for (var cellIndex = 0; cellIndex < settings.cells; cellIndex++)
        {
            let position = BlockPoint(x: cellIndex%settings.cellColumns, y: cellIndex/settings.cellColumns, size: settings.cellSize);
            //Create the new cropping rectangle and get a subimage from the current frame
            var rect = CGRectMake(position.pixelPoint.point.x, position.pixelPoint.point.y, CGFloat(settings.cellSize), CGFloat(settings.cellSize));
            
            //Add the cell to the array
            cells.append(HashedCell(image: frame.imageByCroppingToRectWithTranslate(rect)));
        }
    }
    
    /*
    *   === PROTOCOLS ===
    */
    var hashValue : Int
    {
        get
        {
            //REPLACE WITH PROPER HASH
            return cells.description.hashValue;
        }
    }
    
    var description : String
    {
        get
        {
            return cells.description;
        }
    }
}