//
//  ImageSettings.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2015-03-11.
//  Copyright (c) 2015 Two Amadios. All rights reserved.
//

import Foundation

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