//
//  HashedCell.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2015-03-11.
//  Copyright (c) 2015 Two Amadios. All rights reserved.
//

import Foundation
import AppKit

func ==(lhs: HashedCell, rhs: HashedCell) -> Bool
{
    return lhs.hashValue == rhs.hashValue;
}

class HashedCell : Hashable, Printable
{
    //The backing CIImage for writing etc.
    var image:CIImage;
    
    //An array of pixel data
    var data:[CUnsignedChar];
    
    init(image:CIImage)
    {
        self.image = image;
        self.data = self.image.rawData();
    }
    
    var hashValue : Int
    {
        get
        {
            var hash:Int = 0;            
            for dataPoint in data
            {
                hash = 12347&*hash &+ Int(dataPoint);
            }
            return hash;
        }
    }
    
    var description: String
    {
        return String(self.hashValue);
    }
}