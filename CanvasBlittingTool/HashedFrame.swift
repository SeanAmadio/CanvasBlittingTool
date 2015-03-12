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
            let position = CellPoint(x: cellIndex%settings.cellColumns, y: (settings.cellColumns-1)-(cellIndex/settings.cellColumns), size: settings.cellSize);
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