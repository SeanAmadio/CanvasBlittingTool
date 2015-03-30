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
    //An array of pixel data
    var data:[CUnsignedChar];
    var hashValue = 0;
    
    init(data:[CUnsignedChar])
    {
        self.data = data;
        for dataPoint in data
        {
            self.hashValue = 12347&*self.hashValue &+ Int(dataPoint);
        }
    }
    
    var description: String
    {
        return String(self.hashValue);
    }
}