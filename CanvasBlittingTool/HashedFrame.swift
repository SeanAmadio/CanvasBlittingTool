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
struct CellData
{
    var size:Int;
    var rows:Int;
    var columns:Int;
    var cells:Int
    {
        get
        {
            return rows*columns;
        }
    }
    
    //Returns the numbers of bits needed to represent these dimensions
    var writeBits:Int
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
    var cells:[[HashedCell]];
    
    init(frame:CIImage, cellData: CellData)
    {
        //Fill with null data
        self.cells = Array<Array<HashedCell>>();
        
        //Parse into the cells array
        var position = BlockPoint(x: 0, y: 0);
        for position.y = cellData.columns-1; position.y >= 0; position.y--
        {
            for position.x = 0; position.x < cellData.rows; position.x++
            {
                //Create the new cropping rectangle and get a subimage from the current frame
                var rect = CGRectMake(position.pixelPoint.point.x, position.pixelPoint.point.y, CGFloat(cellData.size), CGFloat(cellData.size));
                
                //Add the cell to the array
                cells[position.x][position.y] = HashedCell(image: frame.imageByCroppingToRectWithTranslate(rect));
            }
        }
    }
    
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