//
//  Points.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2015-03-03.
//  Copyright (c) 2015 Two Amadios. All rights reserved.
//

import Foundation

struct PixelPoint
{
    var x = 0;
    var y = 0;
    
    var point:CGPoint
    {
        get
        {
            return CGPointMake(CGFloat(x), CGFloat(y));
        }
        set(point)
        {
            x = Int(point.x);
            y = Int(point.y);
        }
    }
}

struct BlockPoint
{
    var x = 0;
    var y = 0;
    var size = 8;
    
    var pixelPoint:PixelPoint
    {
        get
        {
            return PixelPoint(x: x*size, y: y*size);
        }
        set(point)
        {
            x = point.x / size;
            y = point.y / size;
        }
    }
    
    var point:CGPoint
    {
        get
        {
            return CGPointMake(CGFloat(x), CGFloat(y));
        }
        set(point)
        {
            x = Int(point.x);
            y = Int(point.y);
        }
    }
}