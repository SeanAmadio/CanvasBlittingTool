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
    var blockPoint:BlockPoint
    {
        get
        {
            return BlockPoint(x: x/8, y: y/8);
        }
        set(point)
        {
            x = point.x*8;
            y = point.y*8;
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

struct BlockPoint
{
    var x = 0;
    var y = 0;
    var pixelPoint:PixelPoint
    {
        get
        {
            return PixelPoint(x: x*8, y: y*8);
        }
        set(point)
        {
            x = point.x / 8;
            y = point.y / 8;
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