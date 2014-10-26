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
    
    var imageArray: [NSImage] = [];
    
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
        var dialog = NSOpenPanel();
        dialog.canChooseFiles = true;
        dialog.allowsMultipleSelection = true;
        dialog.canChooseDirectories = false;
        
        var imageArrayLock = NSLock();
        
        dialog.beginWithCompletionHandler { (Int result) -> Void in
            if (result == NSFileHandlingPanelOKButton)
            {
                var urls = dialog.URLs;
                
                for url in urls as [NSURL]
                {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                        var image : NSImage! = NSImage(contentsOfFile: url.path!);
                        imageArrayLock.lock();
                        self.imageArray.append(image);
                        imageArrayLock.unlock();
                        NSLog(url.path!);
                    });
                }
            }
        };
    }

}

