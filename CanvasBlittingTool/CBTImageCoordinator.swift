//
//  CBTImageCoordinator.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2014-12-08.
//  Copyright (c) 2014 Two Amadios. All rights reserved.
//

import Cocoa

class CBTImageCoordinator: CBTCoordinator
{
    var image:CIImage?;
    var index:Int = 0;
    //Cells stores the cells we have written, keyed by their hash so we can easily check for duplicates
    var cells = Dictionary<HashedCell, Int>();
    
    func addCell(cell: HashedCell, callbackClosure: (Int) -> Void)
    {
        var operation = NSBlockOperation { () -> Void in
            //Write block at current draw point
            
            /*let transform = NSAffineTransform();
            transform.translateXBy(self.position.pixelPoint.point.x, yBy: self.position.pixelPoint.point.y);
            NSLog("----[Wrote to %f,%f]", self.position.pixelPoint.point.x, self.position.pixelPoint.point.y);
            
            let shiftFilter = CIFilter(name: "CIAffineTransform");
            shiftFilter.setValue(block, forKey: kCIInputImageKey);
            shiftFilter.setValue(transform, forKey: kCIInputTransformKey);
            
            let compositeFilter = CIFilter(name: "CISourceOverCompositing");
            compositeFilter.setValue(shiftFilter.outputImage, forKey: kCIInputImageKey);
            compositeFilter.setValue(self.image, forKey: kCIInputBackgroundImageKey);
            self.image = compositeFilter.outputImage;
            
            //Callback with point where image was drawn
            callbackClosure(self.position);
            //Move draw point forward
            self.position.x++;
            if (self.position.x == self.width)
            {
                self.position.x = 0;
                self.position.y--;
            }*/
            //If we already have the cell in our list just use that position
            if (self.cells[cell] != nil)
            {
                callbackClosure(self.cells[cell]!);
                NSLog("---[Cell Exists at %i]" , self.cells[cell]!);
            }
            else
            {
                //Add a new entry with the index, callback and increments
                self.cells[cell] = self.index;
                callbackClosure(self.index);
                NSLog("---[Cell Written at %i]" , self.index);
                self.index++;
            }
        };
        self.modifyQueue.addOperation(operation);
    }
    
    func writeImage()
    {
        let width = Int(ceil(sqrt(Float(self.cells.count))));
        let height = Int(ceil(Float(self.cells.count)/Float(width)));
        
        self.image = NSImage(size: CGSizeMake(CGFloat(width*8), CGFloat(height*8))).unscaledCIImage();
        
        for (cell, index) in cells
        {
            let position = BlockPoint(x: index%width, y: height-(index/width), size: 8);
            
            let transform = NSAffineTransform();
            transform.translateXBy(position.pixelPoint.point.x, yBy: position.pixelPoint.point.y);
            NSLog("----[Index %i Wrote to %f,%f]", index, position.pixelPoint.point.x, position.pixelPoint.point.y);
            
            let shiftFilter = CIFilter(name: "CIAffineTransform");
            shiftFilter.setValue(cell.image, forKey: kCIInputImageKey);
            shiftFilter.setValue(transform, forKey: kCIInputTransformKey);
            
            let compositeFilter = CIFilter(name: "CISourceOverCompositing");
            compositeFilter.setValue(shiftFilter.outputImage, forKey: kCIInputImageKey);
            compositeFilter.setValue(self.image, forKey: kCIInputBackgroundImageKey);
            self.image = compositeFilter.outputImage;
        }
        
        self.image!.writeToPNG("output2.png");
    }
}
