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
            
            //If we already have the cell in our list just use that position
            if (self.cells[cell] != nil)
            {
                callbackClosure(self.cells[cell]!);
                NSLog("---[Cell Exists at %i]" , self.cells[cell]!);
            }
            else
            {
                //Add a new entry with the index, callback and increment
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
        
        //Write each of the cells onto the final image
        for (cell, index) in cells
        {
            //Find the cell space position from the index, starting at the top left
            let position = CellPoint(x: index%width, y: height-(index/width), size: 8);
            
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
        
        //Write the image to file
        self.image!.writeToPNG("output2.png");
    }
}
