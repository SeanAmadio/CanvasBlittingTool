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
            //REPLACE WITH PROPER HASH
            return data.description.hashValue;
        }
    }
    
    var description: String
    {
        return String(self.hashValue);
    }
}