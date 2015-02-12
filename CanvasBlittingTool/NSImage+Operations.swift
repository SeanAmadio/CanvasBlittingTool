//
//  NSImage+Operations.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2015-02-12.
//  Copyright (c) 2015 Two Amadios. All rights reserved.
//

import Foundation
import AppKit

extension NSImage
{
    func isBlack()->Bool
    {
        //Not sure if this is going to work or be efficient (probably not)
        let black = NSImage(size: self.size);
        black.backgroundColor = NSColor.blackColor();
        return self.TIFFRepresentation!.isEqualToData(black.TIFFRepresentation!);
    }
}
