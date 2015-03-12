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
            self.cells[cell] = self.index;
            self.index++;
        };
        self.modifyQueue.addOperation(operation);
    }
}
