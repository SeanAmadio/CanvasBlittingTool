//
//  ViewController.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2014-10-21.
//  Copyright (c) 2014 Two Amadios. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController {

    @IBOutlet weak var blockSizePopup: NSPopUpButton!
    @IBOutlet weak var frameratePopup: NSPopUpButton!
    @IBOutlet weak var hashComparisonCheck: NSButton!
    @IBOutlet weak var loopCheck: NSButton!
    @IBOutlet weak var animationView: CBTAnimationView!
    
    var imageArray:[NSImage?] = [];
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override var representedObject: AnyObject?
        {
        didSet
        {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func openFileAction(sender: NSButton)
    {
        //Pop the dialog
        var dialog = NSOpenPanel();
        dialog.canChooseFiles = true;
        dialog.allowsMultipleSelection = true;
        dialog.canChooseDirectories = false;
        
        //Set up the multithreaded image loading
        var imageArrayLock = NSLock();
        var imageLoadQueue = NSOperationQueue();
        
        dialog.beginWithCompletionHandler { (Int result) -> Void in
            if (result == NSFileHandlingPanelOKButton)
            {
                var urls = dialog.URLs;
                
                self.imageArray = [NSImage?](count: urls.count, repeatedValue: nil);
                for (index, object) in enumerate(urls)
                {
                    var url = object as NSURL;
                    imageLoadQueue.addOperation(NSBlockOperation(block: { () -> Void in
                        var image : NSImage! = NSImage(contentsOfFile: url.path!);
                        imageArrayLock.lock();
                        self.imageArray[index] = image;
                        imageArrayLock.unlock();
                        NSLog(url.path!);
                    }))
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    imageLoadQueue.waitUntilAllOperationsAreFinished();
                    self.animationView.setAnimation(self.imageArray);
                });
            }
        };
    }

}

